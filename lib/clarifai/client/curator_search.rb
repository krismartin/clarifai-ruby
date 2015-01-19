module Clarifai
  class Client
    # Defines methods related to Curator Index management
    module CuratorSearch
      def search(index, query, search_options={}, options={})
        options.merge!({
          query_string: query
        })
        options.merge!(size: (search_options[:size] || 50))
        puts options
        response = post("index/#{index}", options, Faraday::FlatParamsEncoder)
        response
      end
    end
  end
end
