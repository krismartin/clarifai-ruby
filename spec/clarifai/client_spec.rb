require 'minitest/spec'
require 'minitest/autorun'

require 'faraday'
require 'clarifai'

describe Clarifai::Client do

  let(:client_id) { ENV["CLARIFAI_CLIENT_ID"] }
  let(:client_secret) { ENV["CLARIFAI_CLIENT_SECRET"] }

  # Runs codes before each expectation
  before do
    Clarifai.reset
    @client = Clarifai::Client.new(client_id: client_id, client_secret: client_secret)
  end

  it "should connect using the endpoint configuration" do
    endpoint = URI.parse(@client.endpoint)
    connection = @client.send(:connection).build_url(nil).to_s
    (connection).must_equal endpoint.to_s
  end

  describe ".access_token" do
    it "should not be nil" do
      @client.access_token.wont_be_nil
    end
  end

  describe ".access_token_expires_at" do
    it "should be in the future" do
      @client.access_token_expires_at.must_be :>, Time.now.utc
    end
  end
end
