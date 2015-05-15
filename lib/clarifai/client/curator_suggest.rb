module Clarifai
  class Client
    # Defines methods related to Curator Document management
    module CuratorSuggest
      #
      # Get suggestions for tags for a given collection
      #
      def tag_suggest(collection_id, tag_prefix)
        params = {
          suggest: {
            tag_prefix: tag_prefix
          }
        }

        response = post("curator/collections/#{collection_id}/suggest", params.to_json, params_encoder, encode_json=true)
        response
      end
    end
  end
end
