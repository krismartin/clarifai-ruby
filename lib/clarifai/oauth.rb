module Clarifai
  # Defines HTTP request methods
  module OAuth
    # Return an access token from authorization
    def get_access_token(options={})
      params = {grant_type: options[:grant_type] ||= self.auth_grant_type}
      auth_response = post("/token/", params, params_encoder, encode_json=false, raw=false, no_response_wrapper=true)
      self.access_token = auth_response[:access_token]
      self.access_token_expires_at = Time.now.utc + auth_response.expires_in if (!auth_response.expires_in.nil? && auth_response.expires_in!="")
      return auth_response
    end
  end
end
