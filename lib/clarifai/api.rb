require File.expand_path('../connection', __FILE__)
require File.expand_path('../request', __FILE__)
require File.expand_path('../oauth', __FILE__)

module Clarifai
  # @private
  class API
    # @private
    attr_accessor *Configuration::VALID_OPTIONS_KEYS
    attr_accessor :access_token_expires_at

    # Creates a new API
    def initialize(options={})
      options = Clarifai.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end

      # Initialize access token if api_key is not being used and access_token has not been set
      if (!self.api_key_set? && !self.access_token_set?)
        get_access_token
      end
    end

    def api_key_set?
      self.api_key && !self.api_key.empty?
    end

    def access_token_set?
      self.access_token && !self.access_token.empty?
    end

    def config
      conf = {}
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        conf[key] = send key
      end
      conf
    end

    include Connection
    include Request
    include OAuth
  end
end
