require 'spec_helper'

class Clarifai::Client::OutputSpec < MiniTest::Spec

  describe Clarifai::Client::Output do
    before do
      Clarifai.reset
      @@client = Clarifai::Client.new(client_id: client_id, client_secret: client_secret)
    end

    # TODO
    describe ".get_output" do
      describe "when given an empty input id" do
        it "must raise an ArgumentError" do
          err = ->{ @@client.get_output(nil) }.must_raise ArgumentError
        end
      end
    end
  end

end
