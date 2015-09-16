require 'spec_helper'

class Clarifai::Client::DocumentAnnotationSpec < MiniTest::Spec
  @@client = nil

  let(:collection_name) { collection_id + "-document_annotation_test" }

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

  before do
    if @@client.nil?
      Clarifai.reset
      @@client = Clarifai::Client.new(client_id: client_id, client_secret: client_secret, collection_id: collection_name)
      create_collection(@@client, collection_name)
    end
  end

  describe Clarifai::Client do

    before do
      create_document(@@client, @@client.collection_id, image)
    end

    after do
      delete_document(@@client, @@client.collection_id, image[:id])
    end

    describe ".update_document_annotation" do
      it "should create new annotation to the default namespace" do
        response = @@client.get_document @@client.collection_id, image[:id]
        default_annotation = response.document.annotation_sets.detect{|as| as.namespace == "default"}
        default_annotation_count = default_annotation.annotations.count

        response = @@client.update_document_annotation @@client.collection_id, image[:id], actioner="moderator", namespace="default", ['cat'], score=1.0
        response.status.status.must_equal "OK"
        response.updated.must_equal true
        response.docid.must_equal image[:id]

        response = @@client.get_document @@client.collection_id, image[:id]
        default_annotation = response.document.annotation_sets.detect{|as| as.namespace == "default"}
        default_annotation.annotations.detect{|a| a.tag.cname == 'cat'}.wont_be_nil
        default_annotation.annotations.count.must_equal (default_annotation_count+1)
      end

      it "should create new annotation in the given namespace" do
        @@client.update_document_annotation @@client.collection_id, image[:id], actioner="user", namespace="user-defined", ['dog'], score=1.0
        @@client.update_document_annotation @@client.collection_id, image[:id], actioner="user", namespace="user-defined", ['puppy'], score=1.0
        response = @@client.update_document_annotation @@client.collection_id, image[:id], actioner="user", namespace="user-defined", ['canine'], score=1.0

        response.status.status.must_equal "OK"
        response.updated.must_equal true
        response.docid.must_equal image[:id]

        response = @@client.get_document @@client.collection_id, image[:id]
        user_defined_annotation = response.document.annotation_sets.detect{|as| as.namespace == "user-defined"}
        user_defined_annotation.annotations.collect{|a| a.tag.cname}.sort.must_equal ['dog', 'puppy', 'canine'].sort
      end

      it "should set the annotation score" do
        response = @@client.update_document_annotation @@client.collection_id, image[:id], actioner="user", namespace="user-defined", ['dog'], score=1.0
        response.status.status.must_equal "OK"
        response.updated.must_equal true
        response.docid.must_equal image[:id]

        response = @@client.get_document @@client.collection_id, image[:id]
        user_defined_annotation = response.document.annotation_sets.detect{|as| as.namespace == "user-defined"}
        user_defined_annotation.annotations.detect{|a| a.tag.cname == 'dog'}.score.must_equal 1.0
      end
    end

    describe ".delete_document_annotation" do
      it "should delete the annotation from the given namespace" do
        @@client.update_document_annotation @@client.collection_id, image[:id], actioner="user", namespace="user-defined", ['dog'], score=1.0
        @@client.update_document_annotation @@client.collection_id, image[:id], actioner="user", namespace="user-defined", ['puppy'], score=1.0
        @@client.update_document_annotation @@client.collection_id, image[:id], actioner="user", namespace="user-defined", ['cat'], score=1.0
        @@client.update_document_annotation @@client.collection_id, image[:id], actioner="user", namespace="user-defined", ['feline'], score=1.0

        response = @@client.delete_document_annotation @@client.collection_id, image[:id], actioner="user", namespace="user-defined", ['cat', 'feline']
        response.annotations_deleted.must_equal true
        response.docid.must_equal image[:id]

        response = @@client.get_document @@client.collection_id, image[:id]
        user_defined_annotation = response.document.annotation_sets.detect{|as| as.namespace == "user-defined"}
        deleted_annotations = user_defined_annotation.annotations.find_all{|a| a["status"] && a["status"]["is_deleted"]}

        user_defined_annotation.annotations.count.must_equal 4
        deleted_annotations.count.must_equal 2
        deleted_annotations.collect{|a| a.tag.cname}.sort.must_equal ["cat", "feline"].sort
      end
    end

  end
end
