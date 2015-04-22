module Clarifai
  class Client
    # Defines methods related to Curator Collection management
    module CuratorCollection
      def get_collection(collection_id)
        response = get("curator/collections/#{collection_id}")
        response
      end

      def create_collection(collection_id, collection_settings={}, collection_properties={})
        collection_attributes = { id: collection_id }
        collection_attributes[:settings] = collection_settings unless collection_settings.empty?
        collection_attributes[:properties] = collection_properties unless collection_properties.empty?
        params = { collection: collection_attributes }
        response = post("curator/collections", params.to_json, params_encoder, encode_json=true)
        response
      end

      def delete_collection(collection_id)
        response = delete("curator/collections/#{collection_id}", {}.to_json, params_encoder, encode_json=true)
        response
      end
    end
  end
end
