require 'spec_helper'

class Clarifai::Client::SearchSpec < MiniTest::Spec
  @@client = nil
  @@search_response = nil

  let(:collection_name) { collection_id + "-search_test" }

  before do
    if @@client.nil? || @@search_response.nil?
      Clarifai.reset
      @@client = Clarifai::Client.new(client_id: client_id, client_secret: client_secret, collection_id: collection_name)
      create_collection(@@client, collection_name)
      create_documents(@@client, collection_name)
      @@search_response = @@client.search collection_name, tags: ["nobody"]
    end
  end

  describe Clarifai::Client do

    describe ".search" do

      describe "response object when successful" do

        it "should have status" do
          @@search_response.status.status.must_equal "OK"
        end

        it "should have the total number of results" do
          @@search_response.total_num_results.must_be_kind_of Integer
        end

        it "should have the array of results" do
          @@search_response.results.must_be_kind_of Array
        end

      end

      describe "search results" do

        it "should be ordered by overall scores in descending order" do
          scores = @@search_response.results.collect{|r| r.score}
          @@search_response.results.collect{|r| r.score}.must_equal scores.sort.reverse
        end

        it "should be paginated" do
          unpaginated_results = @@search_response.results.collect{|r| r.document.docid}
          total_num_results = @@search_response.total_num_results
          per_page = 2
          total_pages = (total_num_results + per_page - 1) / per_page

          puts "\nunpaginated_results: #{unpaginated_results.join(', ')}"

          total_pages.times do |index|
            page = index+1
            start = (page==1 ? 0 : ((page-1)*per_page))
            response = @@client.search collection_name, tags: ['nobody'], per_page: per_page, start: start
            results = response.results.collect{|r| r.document.docid}
            puts "Start: #{start}, Per page: #{per_page}: #{results.join(', ')}\n"
            results.must_equal unpaginated_results[start..(start+per_page)-1]
          end
        end

      end

      describe "search result item" do

        it "should have overall score" do
          search_item = @@search_response.results.first
          search_item.score.must_be_kind_of Float
        end

        it "should have document" do
          search_item = @@search_response.results.first
          search_item.document.wont_be_nil
        end

        describe "document" do

          it "should have annotation_sets" do
            document = @@search_response.results.first.document
            document.annotation_sets.must_be_kind_of Array
          end

          it "should have media_refs" do
            document = @@search_response.results.first.document
            document.media_refs.must_be_kind_of Array
          end

          it "should have docid" do
            document = @@search_response.results.first.document
            document.docid.wont_be_nil
          end

          it "should have metadata" do
            document = @@search_response.results.first.document
            document.metadata.must_be_kind_of Hash
          end

        end

      end

      describe "with top_tags passed" do

        it "should return the aggregated tags" do
          response = @@client.search collection_name, { tags: ['nobody'] }, { top_tags: 10 }
          response.aggregations.top_tags.top_tags.buckets.count == 10
        end

        describe "tag" do

          it "should have key and doc_count" do
            response = @@client.search collection_name, { tags: ['nobody'] }, { top_tags: 10 }
            tag = response.aggregations.top_tags.top_tags.buckets.first
            tag["key"].wont_be_nil
            tag["doc_count"].must_be_kind_of Integer
          end

        end

      end

    end

  end
end
