module Clarifai
  class Client
    # Defines methods related to Curator Collection search
    module CuratorSearch
      def search(collection_id, search_options={})
        response = post("curator/collections/#{collection_id}/search", search_options.to_json, params_encoder, encode_json=true)
        response
      end

      def query_string_search(collection_id, query, size=50, start=0, metadata_filters={})
        options = {
          num: size,
          start: start
        }

        if metadata_filters.present?
          options[:query] = {
            bool: {
              must: [
                { query_string: query },
                { term: metadata_filters }
              ]
            }
          }
        else
          options[:query] = { query_string: query }
        end

        search(collection_id, options)
      end

      def tags_search(index, tags, size=50, start=0, metadata_filters={})
        tags = [tags] if tags.is_a? String

        options = {
          num: size,
          start: start
        }

        if metadata_filters.present?
          options[:query] = {
            bool: {
              must: [
                construct_query_tags(tags),
                { term: metadata_filters }
              ]
            }
          }
        else
          options[:query] = construct_query_tags(tags)
        end

        search(index, options)
      end

      def similar_search(index, image_urls_or_doc_ids, size=50, start=0, metadata_filters={})
        image_urls_or_doc_ids = [image_urls_or_doc_ids] if image_urls_or_doc_ids.is_a? String
        similar_search_type = determine_image_urls_or_doc_ids(image_urls_or_doc_ids)

        options = {
          num: size,
          start: start
        }

        if metadata_filters.present?
          options[:query] = {
            bool: {
              must: [
                { similar_search_type => image_urls_or_doc_ids },
                { term: metadata_filters }
              ]
            }
          }
        else
          options[:query] = { similar_search_type => image_urls_or_doc_ids }
        end

        search(index, options)
      end

      private
      def construct_query_tags(tags)
        query = {}
        if tags.is_a? Array
          query[:tags] = tags
        elsif tags.is_a? Hash
          query[:tags] = { tags: tags }
        end
        return query
      end

      def determine_image_urls_or_doc_ids(image_urls_or_doc_ids)
        if image_urls_or_doc_ids.collect{|val| val.match(/^http/).present?}.include?(false)
          'similar_items'
        else
          'similar_urls'
        end
      end
    end
  end
end
