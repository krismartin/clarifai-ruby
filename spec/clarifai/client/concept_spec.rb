require 'spec_helper'

class Clarifai::Client::ConceptSpec < MiniTest::Spec
  @@client = nil
  @@update_input_concepts_response = nil
  @@delete_input_concepts_response = nil

  let(:image) {{
    id: SecureRandom.hex,
    url: "http://farm6.staticflickr.com/5323/18223890844_baa427cbbe_b.jpg",
    concepts: [
      'calm', 'tranquility', 'blue'
    ]
  }}

  describe Clarifai::Client do
    before do
      Clarifai.reset
      @@client = Clarifai::Client.new(client_id: client_id, client_secret: client_secret)
    end

    describe ".update_input_concepts" do
      describe "when given an empty ID" do
        it "must raise an ArgumentError" do
          err = ->{ @@client.update_input_concepts("", image[:concepts]) }.must_raise ArgumentError
        end
      end

      describe "when given an empty concepts" do
        it "must raise an ArgumentError" do
          err = ->{ @@client.update_input_concepts(image[:id], []) }.must_raise ArgumentError
        end
      end

      describe "when given a non-existence ID" do
        before do
          @@update_input_concepts_response = @@client.update_input_concepts("123", image[:concepts])
        end

        describe "response object" do
          it "should have a status code equal to 11101" do
            @@update_input_concepts_response.status.code.must_equal 11101
          end
        end
      end

      describe "when given a valid arguments" do
        before do
          @@client.create_input(image[:url], id: image[:id])
        end

        describe "when given an array of Strings as concepts" do
          before do
            @@update_input_concepts_response = @@client.update_input_concepts(image[:id], image[:concepts])
          end

          it "should add the given concepts to the input" do
            @@update_input_concepts_response.input.data.concepts.collect{|c| c['name']}.sort.must_equal image[:concepts].sort
          end
        end

        describe "when given an array of Hashes as concepts" do
          before do
            @@update_input_concepts_response = @@client.update_input_concepts(image[:id], image[:concepts].collect{|c| { id: c, value: true }})
          end

          it "should add the given concepts to the input" do
            @@update_input_concepts_response.input.data.concepts.collect{|c| c['name']}.sort.must_equal image[:concepts].sort
          end
        end

        describe "when changing a concept value" do
          before do
            @@update_input_concepts_response = @@client.update_input_concepts(image[:id], image[:concepts].collect{|c| { id: c, value: false }})
          end

          it "should change the concept values from true to false" do
            @@update_input_concepts_response.input.data.concepts.collect{|c| c[:value]}.must_equal image[:concepts].collect{|c| 0}
          end
        end

        after do
          @@client.delete_input(image[:id])
        end
      end
    end

    describe ".delete_input_concepts" do
      describe "when given an empty ID" do
        it "must raise an ArgumentError" do
          err = ->{ @@client.delete_input_concepts("", image[:concepts]) }.must_raise ArgumentError
        end
      end

      describe "when given an empty concepts" do
        it "must raise an ArgumentError" do
          err = ->{ @@client.delete_input_concepts(image[:id], []) }.must_raise ArgumentError
        end
      end

      describe "when given a non-existence ID" do
        before do
          @@delete_input_concepts_response = @@client.delete_input_concepts("123", image[:concepts])
        end

        describe "response object" do
          it "should have a status code equal to 11101" do
            @@delete_input_concepts_response.status.code.must_equal 11101
          end
        end
      end

      describe "when given a valid arguments" do
        before do
          test_response = @@client.create_input(image[:url], id: image[:id], concepts: image[:concepts])
        end

        describe "when given an array of Strings as concepts" do
          before do
            @@delete_input_concepts_response = @@client.delete_input_concepts(image[:id], image[:concepts].slice(0, 2))
          end

          describe "response object" do
            it "should have a status code equal to 10000" do
              @@delete_input_concepts_response.status.code.must_equal 10000
            end

            it "should have an input" do
              @@delete_input_concepts_response.input.wont_be_nil
            end
          end

          describe "returned input" do
            it "should delete the given concepts from the input" do
              @@delete_input_concepts_response.input.data.concepts.collect{|c| c['name']}.must_equal image[:concepts].slice(2, 3)
            end
          end
        end

        after do
          @@client.delete_input(image[:id])
        end
      end
    end
  end
end
