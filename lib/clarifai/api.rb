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
        get_access_token
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
