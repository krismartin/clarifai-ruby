module Clarifai
  class Client
    # Defines methods related to Curator Index management
    module CuratorDocument
      def get_document(index, doc_id)
        response = get("curator/#{index}/document/#{doc_id}")
        response
      end

      #
      # Example:
      # clarifai.create_document "index_name", "http://example.com/image.jpg", "document-id-xyz", "image", { photographer_id: "photographer-id-123", title: "Photo caption" }
      #
      def create_document(index, url, doc_id, doc_metadata={}, doc_options={})
        options = { document: {}}
        options[:document][:media_refs] = [{
          url: url,
          media_type: 'image' # hardcoded to 'image'
        }]

        unless doc_metadata.empty?
          options[:document][:metadata] = doc_metadata # merge document metadata
        end

        if doc_options.empty?
          doc_options[:want_doc_response] = true
        end

        unless doc_options.empty?
          options[:options] = doc_options # merge document options
        end

        response = put("curator/#{index}/document/#{doc_id}", options.to_json, params_encoder, encode_json=true)
        response
      end
      alias_method :put_document, :create_document

      def create_documents(index, urls, doc_ids, doc_metadatas=[], doc_options={})
        options = { documents: [] }

        # merge document options
        doc_options[:want_doc_response] = true if doc_options.empty?
        options[:options] = doc_options unless doc_options.empty?

        urls.each_with_index do |url, index|
          document = {
            media_refs: [{
              url: url, media_type: 'image'
            }]
          }

          # merge document id
          document[:docid] = doc_ids[index]

          # merge document metadata
          document[:metadata] = doc_metadatas[index] if doc_metadatas[index].present?

          options[:documents] << document
        end

        response = put("curator/#{index}/documents", options.to_json, params_encoder, encode_json=true)
        response
      end
      alias_method :put_documents, :create_documents

      def delete_document(index, doc_id, options={})
        response = delete("index/#{index}/document/#{doc_id}", options, params_encoder, raw=false, no_response_wrapper=true)
        response
      end
    end
  end
end
