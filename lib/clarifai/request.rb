require 'openssl'
require 'base64'

module Clarifai
  # Defines HTTP request methods
  module Request
    # Perform an HTTP GET request
    def get(path, options={}, params_encoder=params_encoder, raw=false, unformatted=false, no_response_wrapper=no_response_wrapper)
      request(:get, path, options, params_encoder, raw, unformatted, no_response_wrapper)
    end

    # Perform an HTTP POST request
    def post(path, options={}, params_encoder=params_encoder, raw=false, unformatted=false, no_response_wrapper=no_response_wrapper)
      request(:post, path, options, params_encoder, raw, unformatted, no_response_wrapper)
    end

    # Perform an HTTP PUT request
    def put(path, options={}, params_encoder=params_encoder, raw=false, unformatted=false, no_response_wrapper=no_response_wrapper)
      request(:put, path, options, params_encoder, raw, unformatted, no_response_wrapper)
    end

    # Perform an HTTP DELETE request
    def delete(path, options={}, params_encoder=params_encoder, raw=false, unformatted=false, no_response_wrapper=no_response_wrapper)
      request(:delete, path, options, params_encoder, raw, unformatted, no_response_wrapper)
    end

    private

    # Perform an HTTP request
    def request(method, path, options, params_encoder=params_encoder, raw=false, unformatted=false, no_response_wrapper=false)
      response = connection(raw).send(method) do |request|
        request.options.params_encoder = params_encoder
        path = formatted_path(path) unless unformatted
        case method
        when :get, :delete
          request.url(path, options)
        when :post, :put
          request.path = path
          request.body = options unless options.empty?
        end
      end

      return response if raw
      return response.body
      # return response.body if no_response_wrapper
      #return Response.create( response.body )
    end

    def formatted_path(path)
      [path, format].compact.join('.')
    end
  end
end
