module Clarifai
  class Client
    # Defines methods related to concept management
    module Concept

      # Get suggestions for concepts from a given model
      # @param [String] model_id Model ID
      # @param [String] keyword
      def search_concepts(model_id, keyword)
        if model_id.nil? || model_id == ""
          raise ArgumentError, 'Model ID cannot contain nil or be empty'
        end

        if keyword.nil? || keyword == ""
          raise ArgumentError, 'Keyword cannot contain nil or be empty'
        end

        params = {
          concept_query: {
            name: keyword
          }
        }
        return post("concepts/searches", params.to_json, params_encoder, encode_json=true)
      end

    end
  end
end
