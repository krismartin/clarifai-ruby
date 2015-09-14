require 'minitest/spec'
require 'minitest/autorun'

require 'faraday'
require 'clarifai'

describe Clarifai::Client do

  let(:client_id) { ENV["CLARIFAI_CLIENT_ID"] }
  let(:client_secret) { ENV["CLARIFAI_CLIENT_SECRET"] }
  let(:collection_id) { "clarifai_minitest_#{Time.now.strftime('%Y%m%d')}" }

  # Runs codes before each expectation
  before do
    Clarifai.reset
    @client = Clarifai::Client.new(client_id: client_id, client_secret: client_secret, collection_id: collection_id)
  end

  describe ".create_collection" do
    after do
      @client.delete_collection @client.collection_id
    end

    it "should return new collection when successful" do
      response = @client.create_collection @client.collection_id, { max_num_docs: 3000000 }
      response.collection.id.must_equal @client.collection_id
      response.collection.settings.max_num_docs.must_equal 3000000
    end

    describe "max_num_docs" do
      it "should not create new collection when max_num_docs is not set" do
        response = @client.create_collection @client.collection_id
        response.status.status.must_equal "ERROR"
      end
    end
  end

  describe ".get_collection" do
    before do
      @client.create_collection @client.collection_id, { max_num_docs: 3000000 }
    end

    after do
      @client.delete_collection @client.collection_id
    end

    it "should get the correct resource" do
      response = @client.get_collection @client.collection_id
      response.collection.id.must_equal @client.collection_id
    end
  end

  describe ".delete_collection" do
    before do
      @client.create_collection @client.collection_id, { max_num_docs: 3000000 }
    end

    it "should delete the collection when successful" do
      response = @client.delete_collection @client.collection_id
      response.deleted.must_equal true
      response.id.must_equal @client.collection_id
    end
  end
end
