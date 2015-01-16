module Clarifai
  class Client
    # Defines methods related to Curator Index management
    module CuratorIndex
      def get_index(index, options={})
        response = get("index/#{index}", options, Faraday::FlatParamsEncoder)
        response
      end

      def create_index(index, options={})
        response = post("index/#{index}", options.merge(index: options[:index]), Faraday::FlatParamsEncoder)
        response
      end
      alias_method :update_index, :create_index

      def delete_index(index, options={})
        response = delete("index/#{index}", options, Faraday::FlatParamsEncoder)
        response
      end
    end
  end
end
