require 'spec_helper'

class Clarifai::Client::DocumentMetadataSpec < MiniTest::Spec
  @@client = nil

  let(:collection_name) { collection_id + "-document_metadata_test" }

  let(:image) {{
    id: "image_1",
    url: "http://farm3.staticflickr.com/2752/4425027236_685ee5fa35_b.jpg",
    type: "image/jpeg",
    metadata: {
      "photographer_name" => "John Doe",
      "photographer_id" => "photographer_1",
      "orientation" => "landscape",
      "license_type" => "royalty-free"
    }
  }}

  #
  # Initialize Clarifai Client & create an empty Collection
  #
  before do
    if @@client.nil?
      Clarifai.reset
      @@client = Clarifai::Client.new(endpoint: api_endpoint, client_id: client_id, client_secret: client_secret, collection_id: collection_name)
      create_collection(@@client, collection_name)
    end
  end

  describe Clarifai::Client do

    #
    # Create a Document into Collection
    #
    before do
      create_document(@@client, @@client.collection_id, image)
    end

    #
    # Delete the Document from the Collection
    #
    after do
      delete_document(@@client, @@client.collection_id, image[:id])
    end

    describe ".create_document_metadata" do

      describe "response object when successful" do

        it "should have OK status" do
          new_metadata = { "camera_model" => "canon" }
          response = @@client.create_document_metadata @@client.collection_id, image[:id], new_metadata
          response.status.status.must_equal "OK"
        end

        it "should have the updated flag" do
          new_metadata = { "camera_model" => "canon" }
          response = @@client.create_document_metadata @@client.collection_id, image[:id], new_metadata
          response.updated.must_equal true
        end

        it "should have the updated document ID" do
          new_metadata = { "camera_model" => "canon" }
          response = @@client.create_document_metadata @@client.collection_id, image[:id], new_metadata
          response.docid.must_equal image[:id]
        end

      end

      it "should overwrite the previous metadata" do
        new_metadata = { "camera_model" => "canon" }
        @@client.create_document_metadata @@client.collection_id, image[:id], new_metadata

        response = @@client.get_document @@client.collection_id, image[:id]
        response.document.metadata.to_hash.must_equal new_metadata
      end

    end

    describe ".update_document_metadata" do

      describe "response object when successful" do

        it "should have OK status" do
          new_metadata = { "camera_model" => "canon" }
          response = @@client.update_document_metadata @@client.collection_id, image[:id], new_metadata
          response.status.status.must_equal "OK"
        end

        it "should have the updated flag" do
          new_metadata = { "camera_model" => "canon" }
          response = @@client.update_document_metadata @@client.collection_id, image[:id], new_metadata
          response.updated.must_equal true
        end

        it "should have the updated document ID" do
          new_metadata = { "camera_model" => "canon" }
          response = @@client.update_document_metadata @@client.collection_id, image[:id], new_metadata
          response.docid.must_equal image[:id]
        end

      end

      it "should add new fields to the metadata" do
        new_metadata = { "camera_model" => "canon" }
        @@client.update_document_metadata @@client.collection_id, image[:id], new_metadata

        response = @@client.get_document @@client.collection_id, image[:id]
        response.document.metadata.to_hash.must_equal image[:metadata].merge(new_metadata)
      end

    end

    describe ".delete_document_metadata" do

      describe "response object when successful" do

        it "should have OK status" do
          delete_metadata = { "license_type" => nil }
          response = @@client.delete_document_metadata @@client.collection_id, image[:id], delete_metadata
          response.status.status.must_equal "OK"
        end

        it "should have the metadata_deleted flag" do
          delete_metadata = { "license_type" => nil }
          response = @@client.delete_document_metadata @@client.collection_id, image[:id], delete_metadata
          response.metadata_deleted.must_equal true
        end

        it "should have the updated document ID" do
          delete_metadata = { "license_type" => nil }
          response = @@client.delete_document_metadata @@client.collection_id, image[:id], delete_metadata
          response.docid.must_equal image[:id]
        end

      end

      it "should delete the correct resource" do
        delete_metadata = { "license_type" => nil }
        @@client.delete_document_metadata @@client.collection_id, image[:id], delete_metadata

        response = @@client.get_document @@client.collection_id, image[:id]
        response.document.metadata.to_hash.must_equal image[:metadata].tap { |hs| hs.delete("license_type") }
      end
    end

  end
end
