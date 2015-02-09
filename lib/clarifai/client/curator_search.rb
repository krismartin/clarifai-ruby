module Clarifai
  class Client
    # Defines methods related to Curator Index management
    module CuratorSearch
      def search(index, search_options={})
        response = post("curator/#{index}/search", search_options.to_json, params_encoder, encode_json=true)
        response
      end

      def query_string_search(index, query, size=50, start=0, search_options={})
        options = {
          query: { query_string: query },
          num: size,
          start: start
        }
        search(index, options)
      end

      def tags_search(index, tags, size=50, start=0, search_options={})
        tags = [tags] if tags.is_a? String
        options = {
          query: { tags: tags },
          num: size,
          start: start
        }
        search(index, options)
      end

      def similar_search(index, image_urls, size=50, start=0, search_options={})
        image_urls = [image_urls] if image_urls.is_a? String
        options = {
          query: { similar_urls: image_urls },
          num: size,
          start: start
        }
        search(index, options)
      end
    end
  end
end
