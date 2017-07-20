require 'faraday'

# @private
module FaradayMiddleware
  # @private
  class ClarifaiApiKeyAuth < Faraday::Middleware
    def call(env)
      env[:request_headers] = env[:request_headers].merge('Authorization' => "Key #{@api_key}")
      @app.call env
    end

    def initialize(app, api_key)
      @app = app
      @api_key = api_key
    end
  end
end
