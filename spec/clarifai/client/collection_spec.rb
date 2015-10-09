require 'spec_helper'

class Clarifai::Client::CollectionSpec < MiniTest::Spec
  @@client = nil
  @@create_collection_response = nil

  let(:collection_name) { collection_id + "-collection_test" }

  #
  # Initialize Clarifai Client and create an empty Collection
  #
  before do
    if @@client.nil? || @@create_collection_response.nil?
      Clarifai.reset
      @@client = Clarifai::Client.new(endpoint: api_endpoint, client_id: client_id, client_secret: client_secret, collection_id: collection_name)
      @@create_collection_response = create_collection(@@client, collection_name)
    end
  end

  describe Clarifai::Client do

    describe ".create_collection" do

      it "cannot be created when max_num_docs is not set" do
        response = @@client.create_collection @@client.collection_id
        response.status.status.must_equal "ERROR"
      end

      describe "response object when successful" do

        it "should have OK status" do
          @@create_collection_response.status.status.must_equal "OK"
        end

        it "should have the newly created collection" do
          @@create_collection_response.collection.wont_be_nil
        end

      end

      describe "collection" do

        it "should have the collection ID" do
          @@create_collection_response.collection.id.must_equal collection_name
        end

        it "should have the collection settings" do
          @@create_collection_response.collection.settings.max_num_docs 3000000
        end

      end

    end

    describe ".get_collection" do

      describe "response object when successful" do

        it "should have OK status" do
          response = @@client.get_collection @@client.collection_id
          response.status.status.must_equal "OK"
        end

        it "should have the collection ID" do
          response = @@client.get_collection @@client.collection_id
          response.collection.wont_be_nil
        end

      end

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

      describe "response object when successful" do

        it "should have OK status" do
          response = @@client.delete_collection new_collection_name
          response.status.status.must_equal "OK"
        end

        it "should have the deleted flag" do
          response = @@client.delete_collection new_collection_name
          response.deleted.must_equal true
        end

        it "should have the deleted collection ID" do
          response = @@client.delete_collection new_collection_name
          response.id.must_equal new_collection_name
        end

      end

      it "should delete the correct resource" do
        @@client.delete_collection new_collection_name
        response = @@client.get_collection new_collection_name
        response.status.status.must_equal "ERROR"
      end

    end
  end
end
