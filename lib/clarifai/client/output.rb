module Clarifai
  class Client
    module Output

      # Retrieves an output by input ID
      # @param [String] input_id Input ID
      def get_output(input_id)
        if input_id.nil? || input_id == ""
          raise ArgumentError, 'Input ID cannot contain nil or be empty'
        end
        return get("inputs/#{input_id}/outputs", {}, params_encoder, encode_json=true)
      end

    end
  end
end
