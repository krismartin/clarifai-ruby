require 'spec_helper'

class Clarifai::Client::DocumentSpec < MiniTest::Spec
  @@client = nil
  @@create_doc_response = nil
  @@get_doc_response = nil

  let(:collection_name) { collection_id + "-document_test" }

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
  # Initialize Clarifai Client, create a new Collection and add a Document into the new Collection
  #
  before do
    if @@client.nil? || @@create_doc_response.nil? || @@get_doc_response.nil?
      Clarifai.reset
      @@client = Clarifai::Client.new(client_id: client_id, client_secret: client_secret, collection_id: collection_name)
      create_collection(@@client, collection_name)
      @@create_doc_response = create_document(@@client, collection_name, image)
      @@get_doc_response = get_document(@@client, collection_name, image[:id])
    end
  end

  describe Clarifai::Client do

    describe ".create_document" do

      describe "response object when successful" do

        it "should have OK status" do
          @@create_doc_response.status.status.must_equal "OK"
        end

        it "should have the newly created document" do
          @@create_doc_response.document.wont_be_nil
        end

      end

      describe "document" do

        it "should have embeddings" do
          document = @@create_doc_response.document
          document.embeddings.must_be_kind_of Array
        end

        it "should have default embedding" do
          document = @@create_doc_response.document
          document.embeddings.detect{|e| e.namespace == 'default'}.wont_be_nil
        end

        it "should have media_refs" do
          document = @@create_doc_response.document
          document.media_refs.must_be_kind_of Array
        end

        it "should have annotation_sets" do
          document = @@create_doc_response.document
          document.annotation_sets.must_be_kind_of Array
        end

        it "should have default annotation_set" do
          document = @@create_doc_response.document
          document.annotation_sets.detect{|e| e.namespace == 'default'}.wont_be_nil
        end

        it "should have docid" do
          document = @@create_doc_response.document
          document.docid.must_equal image[:id]
        end

        it "should have metadata" do
          document = @@create_doc_response.document
          document.metadata.to_hash.must_equal image[:metadata]
        end

        describe "document media_ref" do

          it "should have url" do
            media_ref = @@create_doc_response.document.media_refs.first
            media_ref.url.must_equal image[:url]
          end

          it "should have media_type" do
            media_ref = @@create_doc_response.document.media_refs.first
            media_ref.media_type.wont_be_nil
          end

        end

        describe "document annotation_set" do

          it "should have namespace" do
            annotation_set = @@create_doc_response.document.annotation_sets.first
            annotation_set.namespace.wont_be_nil
          end

          it "should have an array of annotations" do
            annotation_set = @@create_doc_response.document.annotation_sets.first
            annotation_set.annotations.must_be_kind_of Array
          end

          describe "annotation" do

            it "should have a score" do
              annotation = @@create_doc_response.document.annotation_sets.first.annotations.first
              annotation.score.must_be_kind_of Float
            end

            it "should have a tag" do
              annotation = @@create_doc_response.document.annotation_sets.first.annotations.first
              annotation.tag.cname.wont_be_nil
            end

          end
        end
      end
    end

    describe ".get_document" do

      describe "response object when successful" do

        it "should have OK status" do
          @@get_doc_response.status.status.must_equal "OK"
        end

        it "should have the document" do
          @@get_doc_response.document.wont_be_nil
        end

      end

      describe "document" do

        it "should have embeddings" do
          document = @@get_doc_response.document
          document.embeddings.must_be_kind_of Array
        end

        it "should have default embedding" do
          document = @@get_doc_response.document
          document.embeddings.detect{|e| e.namespace == 'default'}.wont_be_nil
        end

        it "should have media_refs" do
          document = @@get_doc_response.document
          document.media_refs.must_be_kind_of Array
        end

        it "should have annotation_sets" do
          document = @@get_doc_response.document
          document.annotation_sets.must_be_kind_of Array
        end

        it "should have default annotation_set" do
          document = @@get_doc_response.document
          document.annotation_sets.detect{|e| e.namespace == 'default'}.wont_be_nil
        end

        it "should have docid" do
          document = @@get_doc_response.document
          document.docid.must_equal image[:id]
        end

        it "should have metadata" do
          document = @@get_doc_response.document
          document.metadata.to_hash.must_equal image[:metadata]
        end

        describe "document media_ref" do

          it "should have url" do
            media_ref = @@get_doc_response.document.media_refs.first
            media_ref.url.must_equal image[:url]
          end

          it "should have media_type" do
            media_ref = @@get_doc_response.document.media_refs.first
            media_ref.media_type.wont_be_nil
          end

        end

        describe "document annotation_set" do

          it "should have namespace" do
            annotation_set = @@get_doc_response.document.annotation_sets.first
            annotation_set.namespace.wont_be_nil
          end

          it "should have an array of annotations" do
            annotation_set = @@get_doc_response.document.annotation_sets.first
            annotation_set.annotations.must_be_kind_of Array
          end

          describe "annotation" do

            it "should have a score" do
              annotation = @@get_doc_response.document.annotation_sets.first.annotations.first
              annotation.score.must_be_kind_of Float
            end

            it "should have a tag" do
              annotation = @@get_doc_response.document.annotation_sets.first.annotations.first
              annotation.tag.cname.wont_be_nil
            end

          end
        end
      end
    end

    describe ".delete_document" do
      let(:new_image) {{
        id: "image_2",
        url: "https://farm3.staticflickr.com/2159/1821846921_94856d4d76_b.jpg",
        type: "image/jpeg",
        metadata: {
          "photographer_name" => "Jane Doe",
          "photographer_id" => "photographer_2",
          "orientation" => "landscape",
          "license_type" => "rights-managed"
        }
      }}

      before do
        create_document(@@client, @@client.collection_id, new_image)
      end

      describe "response object when successful" do

        it "should have OK status" do
          response = @@client.delete_document @@client.collection_id, new_image[:id]
          response.status.status.must_equal "OK"
        end

        it "should have the deleted flag" do
          response = @@client.delete_document @@client.collection_id, new_image[:id]
          response.deleted.must_equal true
        end

        it "should have the deleted document ID" do
          response = @@client.delete_document @@client.collection_id, new_image[:id]
          response.docid.must_equal new_image[:id]
        end

      end

      it "should delete the correct resource" do
        @@client.delete_document @@client.collection_id, new_image[:id]
        response = @@client.get_document @@client.collection_id, new_image[:id]
        response.status.status.must_equal "ERROR"
      end

    end
  end
end
