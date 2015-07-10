module Clarifai
  class Client
    # Defines methods related to Document Annotation management
    module DocumentMediaRef
      def update_document_media_refs(collection_id, doc_id, media_refs)
        media_refs.each_with_index do |media_ref, index|
          if media_ref.is_a? String
            media_refs[index] = { url: media_ref, media_type: 'image' }
          end
        end

        params = { media_refs: media_refs }

        response = post("curator/collections/#{collection_id}/documents/#{doc_id}/media_refs", params.to_json, params_encoder, encode_json=true)
        response
      end
    end
  end
end
