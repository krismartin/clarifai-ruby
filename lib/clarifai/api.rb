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

      # Generate access_token if one is not present
      if (!self.access_token || self.access_token.empty?)
        auth_response = get_access_token
        self.access_token = auth_response[:access_token]
        self.access_token_expires_at = Time.now.utc + auth_response.expires_in if (!auth_response.expires_in.nil? && auth_response.expires_in!="")
      end
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
