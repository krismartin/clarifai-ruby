module Clarifai
  class Client
    # Defines methods related to Document Metadata management
    module DocumentMetadata
      def create_document_metadata(collection_id, doc_id, metadata_fields)
        params = { metadata: metadata_fields }
        response = post("curator/collections/#{collection_id}/documents/#{doc_id}/metadata", params.to_json, params_encoder, encode_json=true)
        response
      end

      def update_document_metadata(collection_id, doc_id, metadata_fields)
        params = { metadata: metadata_fields }
        response = put("curator/collections/#{collection_id}/documents/#{doc_id}/metadata", params.to_json, params_encoder, encode_json=true)
        response
      end

      def delete_document_metadata(collection_id, doc_id, metadata_fields)
        params = { metadata: metadata_fields }
        response = delete("curator/collections/#{collection_id}/documents/#{doc_id}/metadata", params.to_json, params_encoder, encode_json=true)
        response
      end
    end
  end
end
