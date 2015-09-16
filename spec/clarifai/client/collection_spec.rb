require 'spec_helper'

class Clarifai::Client::CollectionSpec < MiniTest::Spec
  @@client = nil
  @@create_collection_response = nil

  let(:collection_name) { collection_id + "-collection_test" }

  before do
    if @@client.nil? || @@create_collection_response.nil?
      Clarifai.reset
      @@client = Clarifai::Client.new(client_id: client_id, client_secret: client_secret, collection_id: collection_name)
      @@create_collection_response = create_collection(@@client, collection_name)
    end
  end

  describe Clarifai::Client do
    describe ".create_collection" do
      it "should not create new collection when max_num_docs is not set" do
        response = @@client.create_collection @@client.collection_id
        response.status.status.must_equal "ERROR"
      end

      it "should return OK status when successful" do
        @@create_collection_response.status.status.must_equal "OK"
      end

      it "should return new collection ID when successful" do
        @@create_collection_response.collection.id.must_equal @@client.collection_id
      end

      it "should return new collection settings when successful" do
        @@create_collection_response.collection.settings.max_num_docs 3000000
      end
    end

    describe ".get_collection" do
      it "should get the correct resource" do
        response = @@client.get_collection @@client.collection_id
        response.collection.id.must_equal @@client.collection_id
      end
    end

    describe ".delete_collection" do
      let(:new_collection_name) { @@client.collection_id + "-2" }

      before do
        @@client.create_collection new_collection_name, { max_num_docs: 3000000 }
      end

      it "should delete the collection when successful" do
        response = @@client.delete_collection new_collection_name
        response.deleted.must_equal true
        response.id.must_equal new_collection_name
      end
    end
  end
end
