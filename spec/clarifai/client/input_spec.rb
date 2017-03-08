require 'spec_helper'

class Clarifai::Client::InputSpec < MiniTest::Spec

  describe Clarifai::Client::Input do
    before do
      Clarifai.reset
      @@client = Clarifai::Client.new(client_id: client_id, client_secret: client_secret)
    end

    # TODO
    describe ".create_input" do
    end

    # TODO
    describe ".get_input" do
      describe "when given an empty input id" do
        it "must raise an ArgumentError" do
          err = ->{ @@client.get_input(nil) }.must_raise ArgumentError
        end
      end
    end

    # TODO
    describe ".delete_input" do
      describe "when given an empty input id" do
        it "must raise an ArgumentError" do
          err = ->{ @@client.delete_input(nil) }.must_raise ArgumentError
        end
      end
    end
  end

end
