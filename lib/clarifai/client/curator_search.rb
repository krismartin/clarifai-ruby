module Clarifai
  class Client
    # Defines methods related to Curator Index management
    module CuratorSearch
      def search(index, query, size=50, page=0, search_options={})
        options = {
          query: { query_string: query },
          num: size,
          start: page
        }
        response = post("curator/#{index}/search", options.to_json, params_encoder, encode_json=true)
        response
      end
    end
  end
end
