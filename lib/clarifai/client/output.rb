module Clarifai
  class Client
    module Output

      # Retrieves an output by input ID
      # @param [String] input_id Input ID
      def get_output(input_id)
        return get("inputs/#{input_id}/outputs", {}, params_encoder, encode_json=true)
      end

    end
  end
end
