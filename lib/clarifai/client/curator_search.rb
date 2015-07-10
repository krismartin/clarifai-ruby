module Clarifai
  class Client
    # Defines methods related to Curator Collection search
    module CuratorSearch

      def search(collection_id, query={}, options={})
        search_query = Clarifai::Search::Query.new(query)

        search_params = {
          num: search_query.per_page,
          start: search_query.page,
          query: search_query.query
        }

        if (!options.nil? && !options.empty?)
          search_params[:options] = {} unless search_params.has_key? :options
          search_params[:options].merge!(options)
        end

        puts "\n\nsearch_params:"
        puts search_params
        response = post("curator/collections/#{collection_id}/search", search_params.to_json, params_encoder, encode_json=true)
        response
      end

    end
  end
end
