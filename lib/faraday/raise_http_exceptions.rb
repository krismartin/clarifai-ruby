require 'faraday'

# @private
module FaradayMiddleware
  # @private
  class RaiseHttpException < Faraday::Middleware
    def call(env)
      @app.call(env).on_complete do |response|
        response_status = response[:status].to_i
        status_code, status_msg = status_code_and_message(response[:body])
        case response_status
        when 400
          raise Clarifai::BadRequest, error_message_400(response, status_code, status_msg)
        when 401
          case status_code
          when 'TOKEN_NONE'
            raise Clarifai::TokenRequired, error_message_400(response, status_code, status_msg)
          when 'TOKEN_APP_INVALID', 'TOKEN_INVALID'
            raise Clarifai::InvalidToken, error_message_400(response, status_code, status_msg)
          when 'TOKEN_EXPIRED'
            raise Clarifai::ExpiredToken, error_message_400(response, status_code, status_msg)
          else
            raise Clarifai::Unauthorized, error_message_400(response, status_code, status_msg)
          end
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

    def error_message_400(response, status_code, status_msg)
      "#{response[:method].to_s.upcase} #{response[:url].to_s}: #{response[:status]}#{error_body(status_code, status_msg)}"
    end

    def body_json(body)
      # body gets passed as a string, not sure if it is passed as something else from other spots?
      if not body.nil? and not body.empty? and body.kind_of?(String)
        # removed multi_json thanks to wesnolte's commit
        return ::JSON.parse(body)
      end
    end

    def status_code_and_message(body)
      body = body_json(body)

      if body.nil?
        return nil, nil
      elsif body['status_msg'] and not body['status_msg'].empty?
        return body['status_code'], body['status_msg']
      end
    end

    def error_body(status_code, status_msg)
      error_body = ""
      error_body << ": #{status_code}" if status_code.present?
      error_body << ": #{status_msg}" if status_msg.present?
      return error_body
    end

    def error_message_500(response, body=nil)
      "#{response[:method].to_s.upcase} #{response[:url].to_s}: #{[response[:status].to_s + ':', body].compact.join(' ')}"
    end
  end
end
