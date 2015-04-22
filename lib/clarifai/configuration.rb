require File.expand_path('../version', __FILE__)

module Clarifai
  # Defines constants and methods related to configuration
  module Configuration
    # An array of valid keys in the options hash when configuring a {Clarifai::API}
    VALID_OPTIONS_KEYS = [
      :client_id,
      :client_secret,
      :client_type,
      :adapter,
      :auth_grant_type,
      :access_token,
      :endpoint,
      :format,
      :user_agent,
      :params_encoder,
      :no_response_wrapper,
      :collection_id
    ].freeze

    # By default, don't set a client ID
    DEFAULT_CLIENT_ID = nil

    # By default, don't set a client secret
    DEFAULT_CLIENT_SECRET = nil

    # The adapter that will be used to connect if none is set
    #
    # @note The default faraday adapter is Net::HTTP.
    DEFAULT_ADAPTER = Faraday.default_adapter

    # The client type that will be used if none set
    DEFAULT_CLIENT_TYPE = 'confidential'

    # The authentication grant type that will be used if none set
    DEFAULT_AUTH_GRANT_TYPE = 'client_credentials'

    # By default, don't set a user access token
    DEFAULT_ACCESS_TOKEN = nil

    # The endpoint that will be used to connect if none is set
    #
    # @note There is no reason to use any other endpoint at this time
    DEFAULT_ENDPOINT = 'https://api.clarifai.com/v1/'.freeze
    # DEFAULT_ENDPOINT = 'https://api-staging.clarifai.com/v1/'.freeze # staging env


    # The response format appended to the path and sent in the 'Accept' header if none is set
    #
    # @note JSON is the only available format at this time
    DEFAULT_FORMAT = :json

    # The user agent that will be sent to the API endpoint if none is set
    DEFAULT_USER_AGENT = "Clarifai Ruby Gem #{Clarifai::VERSION}".freeze

    # The default Faraday params encoder that will be used if none set
    DEFAULT_PARAMS_ENCODER = Faraday::NestedParamsEncoder

    # By default, don't wrap responses with meta data (i.e. pagination)
    DEFAULT_NO_RESPONSE_WRAPPER = false

    # An array of valid request/response formats
    #
    # @note Not all methods support the XML format.
    VALID_FORMATS = [
      :json].freeze

    # @private
    attr_accessor *VALID_OPTIONS_KEYS

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
    end

    # Create a hash of options and their values
    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    # Reset all configuration options to defaults
    def reset
      self.client_id            = DEFAULT_CLIENT_ID
      self.client_secret        = DEFAULT_CLIENT_SECRET
      self.client_type          = DEFAULT_CLIENT_TYPE
      self.adapter              = DEFAULT_ADAPTER
      self.auth_grant_type      = DEFAULT_AUTH_GRANT_TYPE
      self.access_token         = DEFAULT_ACCESS_TOKEN
      self.endpoint             = DEFAULT_ENDPOINT
      self.format               = DEFAULT_FORMAT
      self.user_agent           = DEFAULT_USER_AGENT
      self.params_encoder       = DEFAULT_PARAMS_ENCODER
      self.no_response_wrapper  = DEFAULT_NO_RESPONSE_WRAPPER
    end
  end
end
