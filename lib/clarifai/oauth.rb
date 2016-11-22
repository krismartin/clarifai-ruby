module Clarifai
  # Defines HTTP request methods
  module OAuth
    # Return an access token from authorization
    def get_access_token(options={})
      params = {grant_type: options[:grant_type] ||= self.auth_grant_type}
      post("/token/", params, params_encoder, encode_json=false, raw=false, no_response_wrapper=true)
    end
  end
end
