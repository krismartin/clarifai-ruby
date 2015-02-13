module Clarifai
  class Client
    # Defines methods related to Curator Index management
    module CuratorIndex
      def get_index(index)
        response = get("curator/index/#{index}")
        response
      end

      def create_index(index, index_settings={}, options={})
        options.merge!({index: index_settings}) # merge index options
        response = put("curator/index/#{index}", options.to_json, params_encoder, encode_json=true)
        response
      end
      alias_method :put_index, :create_index
      alias_method :update_index, :create_index

      def delete_index(index)
        response = delete("curator/index/#{index}", {}.to_json, params_encoder, encode_json=true)
        response
      end
    end
  end
end
