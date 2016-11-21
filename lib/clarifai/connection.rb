require 'faraday_middleware'
Dir[File.expand_path('../../faraday/*.rb', __FILE__)].each{|f| require f}

module Clarifai
  # @private
  module Connection
    private

    def connection(raw=false, encode_json=false)
      options = {
        :headers => {'Accept' => "application/#{format}; charset=utf-8", 'User-Agent' => user_agent},
        :url => endpoint,
      }

      Faraday::Connection.new(options) do |connection|
        connection.use FaradayMiddleware::ClarifaiOAuth2, client_id, access_token

        if follow_redirect
          connection.use FaradayMiddleware::FollowRedirects, standards_compliant: true
        end

        if encode_json
          connection.use FaradayMiddleware::EncodeJson
        else
          connection.use Faraday::Request::UrlEncoded
        end
        connection.use FaradayMiddleware::Mashify unless raw
        unless raw
          case format.to_s.downcase
          when 'json' then connection.use Faraday::Response::ParseJson
          end
        end
        # FIXME: Disable this middleware for now
        # connection.use FaradayMiddleware::RaiseHttpException
        connection.adapter(adapter)
      end
    end
  end
end
