require 'faraday'

# @private
module FaradayMiddleware
  # @private
  class ClarifaiOAuth2 < Faraday::Middleware
    def call(env)
      env[:request_headers] = env[:request_headers].merge('Authorization' => "Bearer #{@access_token}")
      @app.call env
    end

    def initialize(app, access_token)
      @app = app
      @access_token = access_token
    end
  end
end
