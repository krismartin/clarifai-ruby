module Clarifai
  class Client
    # Defines methods related to Curator Index management
    module CuratorSearch
      def search(index, search_options={})
        response = post("curator/#{index}/search", search_options.to_json, params_encoder, encode_json=true)
        response
      end

      def query_string_search(index, query, size=50, start=0, metadata_filters={})
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

        search(index, options)
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

      def similar_search(index, image_urls, size=50, start=0, metadata_filters={})
        image_urls = [image_urls] if image_urls.is_a? String
        options = {
          num: size,
          start: start
        }

        if metadata_filters.present?
          options[:query] = {
            bool: {
              must: [
                { similar_urls: image_urls },
                { term: metadata_filters }
              ]
            }
          }
        else
          options[:query] = { similar_urls: image_urls }
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
    end
  end
end
