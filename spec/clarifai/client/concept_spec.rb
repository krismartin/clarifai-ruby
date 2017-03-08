require 'spec_helper'

class Clarifai::Client::ConceptSpec < MiniTest::Spec

  @@client = nil
  @@search_concepts_response = nil

  describe Clarifai::Client::Input do
    before do
      Clarifai.reset
      @@client = Clarifai::Client.new(client_id: client_id, client_secret: client_secret)
    end

    describe ".search_concepts" do
      describe "when given an empty model id" do
        it "must raise an ArgumentError" do
          err = ->{ @@client.search_concepts("", "dog") }.must_raise ArgumentError
        end
      end

      describe "when given a valid model id and search keyword" do
        before do
          @@search_concepts_response = @@client.search_concepts "aaa03c23b3724a16a56b629203edc62c", "beach"
        end

        describe "response object" do
          it "should have status code equal to 10000" do
            @@search_concepts_response.status.code.must_equal 10000
          end

          it "should have concepts" do
            @@search_concepts_response.concepts.must_be_kind_of Array
          end
        end
      end
    end
  end

end
