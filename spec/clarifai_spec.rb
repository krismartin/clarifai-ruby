require 'minitest/spec'
require 'minitest/autorun'

require 'faraday'
require 'clarifai'

describe Clarifai do

  # Runs codes before each expectation
  before do
    Clarifai.reset
  end

  describe ".client" do
    it "should be a Clarifai::Client" do
      Clarifai.client.must_be_kind_of Clarifai::Client
    end
  end

  describe ".client_id" do
    it "should set the client_id" do
      Clarifai.client_id = "abc123-id"
      Clarifai.client_id.must_equal "abc123-id"
    end
  end

  describe ".client_secret" do
    it "should set the client_secret" do
      Clarifai.client_secret = "secretabc123"
      Clarifai.client_secret.must_equal "secretabc123"
    end
  end

  describe ".client_type" do
    it "should return the default client_type" do
      Clarifai.client_type.must_equal Clarifai::Configuration::DEFAULT_CLIENT_TYPE
    end
  end

  describe ".adapter" do
    it "should return the default adapter" do
      Clarifai.adapter.must_equal Clarifai::Configuration::DEFAULT_ADAPTER
    end
  end

  describe ".auth_grant_type" do
    it "should return the default auth_grant_type" do
      Clarifai.auth_grant_type.must_equal Clarifai::Configuration::DEFAULT_AUTH_GRANT_TYPE
    end
  end

  describe ".access_token" do
    it "should set the access_token" do
      Clarifai.access_token = "abc123"
      Clarifai.access_token.must_equal "abc123"
    end
  end

  describe ".endpoint" do
    it "should return the default endpoint" do
      Clarifai.endpoint.must_equal Clarifai::Configuration::DEFAULT_ENDPOINT
    end

    it "should set the endpoint" do
      Clarifai.endpoint = "https://api-staging.clarifai.com"
      Clarifai.endpoint.must_equal "https://api-staging.clarifai.com"
    end
  end

  describe ".format" do
    it "should return the default format" do
      Clarifai.format.must_equal Clarifai::Configuration::DEFAULT_FORMAT
    end
  end

  describe ".user_agent" do
    it "should return the default user_agent" do
      Clarifai.user_agent.must_equal Clarifai::Configuration::DEFAULT_USER_AGENT
    end
  end

  describe ".params_encoder" do
    it "should return the default params_encoder" do
      Clarifai.params_encoder.must_equal Clarifai::Configuration::DEFAULT_PARAMS_ENCODER
    end
  end

  describe ".no_response_wrapper" do
    it "should return the default no_response_wrapper" do
      Clarifai.no_response_wrapper.must_equal Clarifai::Configuration::DEFAULT_NO_RESPONSE_WRAPPER
    end
  end

  describe ".collection_id" do
    it "should set the collection_id" do
      Clarifai.collection_id = "clarifai_test"
      Clarifai.collection_id.must_equal "clarifai_test"
    end
  end

  describe ".configure" do
    Clarifai::Configuration::VALID_OPTIONS_KEYS.each do |key|
      it "should set the #{key}" do
        Clarifai.configure do |config|
          config.send("#{key}=", key)
          Clarifai.send(key).must_equal key
        end
      end
    end
  end

end
