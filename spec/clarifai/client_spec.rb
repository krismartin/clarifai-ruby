require 'spec_helper'

class Clarifai::ClientSpec < MiniTest::Spec
  # @@client = nil

  describe Clarifai::Client do
    describe ".new" do
      before do
        Clarifai.reset
        @client = Clarifai::Client.new(client_id: client_id, client_secret: client_secret)
      end

      it "should initialized an access token" do
        @client.access_token.wont_be_nil
      end

      it "should have an access token that expires in the future" do
        @client.access_token_expires_at.must_be :>, Time.now.utc
      end
    end
  end
end
