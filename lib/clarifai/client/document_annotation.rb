module Clarifai
  class Client
    # Defines methods related to Document Annotation management
    module DocumentAnnotation
      def create_document_annotation(collection_id, doc_id, actioner, namespace, annotations, default_score=1.0)
        params = { annotation_set: { namespace: namespace, annotations: [] } }

        annotations.each do |annotation|
          if annotation.is_a?(String)
            tag = annotation
            score = default_score
          elsif annotation.is_a?(Hash)
            tag = annotation[:tag]
            score = annotation[:score] || default_score
          else
            raise Clarifai::BadRequest
          end
          params[:annotation_set][:annotations] << {
            tag: { cname: tag },
            score: score
          }
        end

        response = post("curator/collections/#{collection_id}/documents/#{doc_id}/annotations", params.to_json, params_encoder, encode_json=true)
        response
      end

      def update_document_annotation(collection_id, doc_id, actioner, namespace, annotations, default_score=1.0)
        params = { annotation_set: { namespace: namespace, annotations: [] } }

        annotations.each do |annotation|
          if annotation.is_a?(String)
            tag = annotation
            score = default_score
          elsif annotation.is_a?(Hash)
            tag = annotation[:tag]
            score = annotation[:score] || default_score
          else
            raise Clarifai::BadRequest
          end
          params[:annotation_set][:annotations] << {
            tag: { cname: tag },
            score: score
          }
        end

        response = put("curator/collections/#{collection_id}/documents/#{doc_id}/annotations", params.to_json, params_encoder, encode_json=true)
        response
      end

      def delete_document_annotation(collection_id, doc_id, actioner, namespace, annotations)
        params = { annotation_set: { namespace: namespace, annotations: [] } }
        annotations.each do |annotation|
          params[:annotation_set][:annotations] << {
            tag: { cname: annotation },
            status: {
              is_deleted: true,
              user_id: actioner
            }
          }
        end

        response = delete("curator/collections/#{collection_id}/documents/#{doc_id}/annotations", params.to_json, params_encoder, encode_json=true)
        response
      end
    end
  end
end
