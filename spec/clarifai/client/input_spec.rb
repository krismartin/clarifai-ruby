require 'spec_helper'

class Clarifai::Client::InputSpec < MiniTest::Spec
  @@client = nil
  @@add_input_response = nil
  @@add_input_response_with_id = nil
  @@add_input_with_concepts_response = nil
  @@add_input_with_metadata_response = nil

  let(:image) {{
    id: "738fc05c7be9fa887743384186c2db6b",
    url: "http://farm6.staticflickr.com/5323/18223890844_baa427cbbe_b.jpg",
    concepts: [
      'calm', 'tranquility', 'blue'
    ],
    metadata: {
      "photographer" => "Evelyn Lehner",
      "photographer_id" => "9e33561c7c4e8125f3d9a8a781aa02ab",
      "orientation" => "landscape",
      "license_type" => "rights_managed"
    }
  }}

  describe Clarifai::Client do
    before do
      Clarifai.reset
      @@client = Clarifai::Client.new(client_id: client_id, client_secret: client_secret)
    end

    describe ".create_input" do
      describe "when given an image url" do
        before do
          # Create the input
          @@add_input_response = @@client.create_input(image[:url])
        end

        describe "response object" do
          it "should have a status property" do
            @@add_input_response.status.code.must_equal 10000
            @@add_input_response.status.description.must_equal "Ok"
          end

          it "should have an inputs property" do
            @@add_input_response.inputs.must_be_kind_of Array
            @@add_input_response.inputs.count.must_equal 1
          end

          describe "returned input" do
            it "should have an ID assigned" do
              @@add_input_response.inputs.first.id.wont_be_nil
            end

            it "should have image URL equal to the given image URL" do
              @@add_input_response.inputs.first.data.image.url.must_equal image[:url]
            end

            it "should have a status" do
              @@add_input_response.inputs.first.status.wont_be_nil
            end
          end
        end

        after do
          # Delete the input
          input_id = @@add_input_response.inputs.first.id
          @@client.delete_input input_id
        end
      end

      describe "when given an image url and an ID" do
        before do
          # Create the input
          @@add_input_response_with_id = @@client.create_input(image[:url], id: image[:id])
        end

        describe "returned input" do
          it "should have ID equal to the given ID" do
            @@add_input_response_with_id.inputs.first.id.must_equal image[:id]
          end
        end

        after do
          # Delete the input
          input_id = @@add_input_response_with_id.inputs.first.id
          @@client.delete_input input_id
        end
      end

      describe "when given an image url and concepts" do
        before do
          # Create the input
          @@add_input_response_with_concepts = @@client.create_input(image[:url], concepts: image[:concepts])
        end

        describe "returned input" do
          it "should have an array of concepts" do
            @@add_input_response_with_concepts.inputs.first.data.concepts.must_be_kind_of Array
          end

          it "should have concepts equal to the given concepts" do
            @@add_input_response_with_concepts.inputs.first.data.concepts.collect{|c| c['id']}.must_equal image[:concepts]
          end
        end

        after do
          # Delete the input
          input_id = @@add_input_response_with_concepts.inputs.first.id
          @@client.delete_input input_id
        end
      end

      describe "when given an image url and metadata" do
        before do
          # Create the input
          @@add_input_response_with_metadata = @@client.create_input(image[:url], metadata: image[:metadata])
        end

        describe "returned input" do
          it "should have a metadata" do
            @@add_input_response_with_metadata.inputs.first.data.metadata.must_be_kind_of Hash
          end

          it "should have metadata equal to the given metadata" do
            returned_metadata = @@add_input_response_with_metadata.inputs.first.data.metadata
            returned_metadata.keys.sort.must_equal image[:metadata].keys.sort
            returned_metadata.values.sort.must_equal image[:metadata].values.sort
          end
        end

        after do
          # Delete the input
          input_id = @@add_input_response_with_metadata.inputs.first.id
          @@client.delete_input input_id
        end
      end
    end

  end
end
