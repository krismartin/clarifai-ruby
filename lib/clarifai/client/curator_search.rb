module Clarifai
  class Client
    # Defines methods related to Curator Index management
    module CuratorSearch
      def search(index, query, size=50, start=0, search_options={})
        options = {
          query: { query_string: query },
          num: size,
          start: start
        }
        response = post("curator/#{index}/search", options.to_json, params_encoder, encode_json=true)
        response
      end

      def similar_search(index, image_urls, size=50, start=0, search_options={})
        image_urls = [image_urls] if image_urls.is_a? String
        options = {
          query: { similar_urls: image_urls },
          num: size,
          start: start
        }
        response = post("curator/#{index}/search", options.to_json, params_encoder, encode_json=true)
        response
      end
    end
  end
end
