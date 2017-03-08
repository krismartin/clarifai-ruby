module Clarifai
  class Client
    # Defines methods related to input metadata management
    module InputMetadata

      # Updates an input metadata
      # @param [String] input_id Input ID
      # @param [Hash] metadata Metadata to be added/updated
      def update_input_metadata(input_id, metadata)
        if input_id.nil? || input_id == ""
          raise ArgumentError, 'Input ID cannot contain nil or be empty'
        end

        if metadata.nil?
          raise ArgumentError, 'Metadata cannot contain nil or be empty'
        end

        if !metadata.is_a?(Hash)
          raise ArgumentError, 'Metadata must be a Hash'
        end

        params = {
          inputs: [
            {
              id: input_id,
              data: {
                metadata: metadata
              }
            }
          ],
          action: 'merge'
        }

        return patch("inputs", params.to_json, params_encoder, encode_json=true)
      end

      # Batch updates inputs metadata
      # @param [Array] inputs Array of inputs to be updated
      def update_inputs_metadata(inputs)
        if inputs.nil?
          raise ArgumentError, 'Inputs cannot contain nil or be empty'
        end

        if !inputs.is_a?(Array)
          raise ArgumentError, 'Inputs must be an Array'
        end

        params = {
          inputs: [],
          action: 'merge'
        }

        inputs.each_with_index do |input, index|
          raise ArgumentError, "inputs[#{index}]: Cannot contain nil or be empty" if input.nil?
          raise ArgumentError, "inputs[#{index}]: Must be a Hash" if !input.is_a?(Hash)
          [{key: :id, type: String}, {key: :metadata, type: Hash}].each do |prop|
            key = prop[:key]
            type = prop[:type]

            if !input.keys.include?(key)
              raise ArgumentError, "inputs[#{index}]: Must supply the :#{key} key on input object"
            end

            if !input[key].is_a? type
              raise ArgumentError, "inputs[#{index}][:#{key}]: Must be a #{type}"
            end

            if input[key].nil?
              raise ArgumentError, "inputs[#{index}][:#{key}]: Cannot contain nil or be empty"
            end
          end

          params[:inputs] <<  {
            id: input[:id],
            data: {
              metadata: input[:metadata]
            }
          }
        end

        return patch("inputs", params.to_json, params_encoder, encode_json=true)
      end

    end
  end
end
