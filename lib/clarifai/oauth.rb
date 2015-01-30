module Clarifai
  # Defines HTTP request methods
  module OAuth
    # Return an access token from authorization
    def get_access_token(options={})
      options[:grant_type] ||= self.auth_grant_type
      params = access_token_params.merge(options)
      post("/token/", params, params_encoder, encode_json=false, raw=false, no_response_wrapper=true)
    end

    private

    def access_token_params
      {
        :client_id => client_id,
        :client_secret => client_secret
      }
    end
  end
end
