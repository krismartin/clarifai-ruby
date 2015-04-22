module Clarifai
  class Client
    # Defines methods related to Curator Document management
    module CuratorDocument
      def get_document(collection_id, doc_id)
        response = get("curator/collections/#{collection_id}/documents/#{doc_id}")
        response
      end

      def get_documents(collection_id)
        response = get("curator/collections/#{collection_id}/documents")
        response
      end

      #
      # Add a document to a collection
      #
      def create_document(collection_id, doc_id, urls, doc_metadata={}, options={})
        document_attributes = { docid: doc_id, media_refs: [] }

        # Set document media refs
        urls = [urls] if urls.is_a? String
        urls.each do |url|
          document_attributes[:media_refs] << {
            url: url,
            media_type: 'image'
          }
        end

        # Set document metadata
        document_attributes[:metadata] = doc_metadata unless doc_metadata.empty?

        # Set options
        options[:want_doc_response] = true if options.empty?

        params = { document: document_attributes, options: options }

        response = post("curator/collections/#{collection_id}/documents", params.to_json, params_encoder, encode_json=true)
        response
      end

      #
      # Add multiple documents to a collection
      #
      def create_documents(index, doc_ids, urls, doc_metadatas=[], options={})
        documents = []

        urls.each_with_index do |url, index|
          document = { media_refs: [] }

          # Set doc id
          document[:docid] = doc_ids[index]

          # Set doc media refs
          if url.is_a? String
            document[:media_refs] << { url: url, media_type: 'image' }
          elsif url.is_a? Array
            url.each do |u|
              document[:media_refs] << { url: u, media_type: 'image' }
            end
          end

          # Set doc metadata
          document[:metadata] = doc_metadatas[index] unless doc_metadatas[index].empty?

          documents << document
        end

        params = { documents: documents }

        # Set options
        options[:want_doc_response] = true if options.empty?
        params[:options] = options

        response = post("curator/collections/#{collection_id}/documents", params.to_json, params_encoder, encode_json=true)
        response
      end

      #
      # Delete a document by docid
      #
      def delete_document(collection_id, doc_id)
        response = delete("curator/collections/#{collection_id}/documents/#{doc_id}", {}.to_json, params_encoder, encode_json=true)
        response
      end

      #
      # Delete multiple documents by docids
      #
      def delete_documents(collection_id, doc_ids)
        params = { documents: doc_ids }
        response = delete("curator/collections/#{collection_id}/documents", params.to_json, params_encoder, encode_json=true)
        response
      end
    end
  end
end
