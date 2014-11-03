require 'faraday'

# @private
module FaradayMiddleware
  # @private
  class RaiseHttpException < Faraday::Middleware
    def call(env)
      @app.call(env).on_complete do |response|
        puts "\tReponse status: #{response[:status]}"
        case response[:status].to_i
        when 400
          raise Clarifai::BadRequest, error_message_400(response)
        when 401
          raise Clarifai::TokenExpired, error_message_400(response)
        when 500
          raise Clarifai::InternalServerError, error_message_500(response, "Something is technically wrong.")
        end
      end
    end

    def initialize(app)
      super app
      @parser = nil
    end

    private

    def error_message_400(response)
      "#{response[:method].to_s.upcase} #{response[:url].to_s}: #{response[:status]}#{error_body(response[:body])}"
    end

    def error_body(body)
      # body gets passed as a string, not sure if it is passed as something else from other spots?
      if not body.nil? and not body.empty? and body.kind_of?(String)
        # removed multi_json thanks to wesnolte's commit
        body = ::JSON.parse(body)
      end

      if body.nil?
        nil
      elsif body['status_msg'] and not body['status_msg'].empty?
        ": #{body['status_code']}: #{body['status_msg']}"
      end
    end

    def error_message_500(response, body=nil)
      "#{response[:method].to_s.upcase} #{response[:url].to_s}: #{[response[:status].to_s + ':', body].compact.join(' ')}"
    end
  end
end
