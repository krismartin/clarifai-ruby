module Clarifai
  class Client
    # Defines methods related to Curator Index management
    module CuratorDocument
      def get_document(index, doc_id, options={})
        response = get("index/#{index}/#{doc_id}", options, Faraday::FlatParamsEncoder)
        response
      end

      #
      # Example:
      # clarifai.create_document "index_name", "http://example.com/image.jpg", "document-id-xyz", "image", { photographer_id: "photographer-id-123", title: "Photo caption" }
      #
      def create_document(index, url, doc_id, doc_type='image', doc_metadata={}, doc_options={}, options={})
        options.merge!(document: {
          media_refs: [{
            url: url,
            media_type: doc_type
          }]
        })
        options[:document].merge!(metadata: doc_metadata) # merge document metadata
        options.merge!(options: doc_options) # merge document options

        response = put("index/#{index}/#{doc_id}", options, Faraday::FlatParamsEncoder)
        response
      end
      alias_method :put_document, :create_document

      def delete_document(index, doc_id, options={})
        response = delete("index/#{index}/#{doc_id}", options, Faraday::FlatParamsEncoder)
        response
      end
    end
  end
end
