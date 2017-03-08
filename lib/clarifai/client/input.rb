module Clarifai
  class Client
    # Defines methods related to input management
    module Input

      # Creates an input using a publicly accessible URL
      # @param [String] image_url publicly accessible image URL to be indexed
      # @option options [String] :id
      # @option options [Array] :concepts
      # @option options [Hash] :metadata
      def create_input(image_url, options={})
        params = { inputs: [InputParameter.input(url: image_url, id: options[:id], concepts: options[:concepts], metadata: options[:metadata])] }
        return post("inputs", params.to_json, params_encoder, encode_json=true)
      end

      # Creates inputs in batches
      # @param [Array] inputs inputs to be created
      def create_inputs(inputs)
        params = {
          inputs: inputs.collect{|input| InputParameter.input(url: input[:url], id: input[:id], concepts: input[:concepts], metadata: input[:metadata])}
        }
        return post("inputs", params.to_json, params_encoder, encode_json=true)
      end

      # Retrieves an input by ID
      # @param [String] input_id Input ID
      def get_input(input_id)
        if input_id.nil? || input_id == ""
          raise ArgumentError, 'Input ID cannot contain nil or be empty'
        end
        return get("inputs/#{input_id}", {}, params_encoder, encode_json=true)
      end

      # Deletes an input by ID
      # @param [String] input_id Input ID
      def delete_input(input_id)
        if input_id.nil? || input_id == ""
          raise ArgumentError, 'Input ID cannot contain nil or be empty'
        end
        return delete("inputs/#{input_id}", {}, params_encoder, encode_json=true)
      end

      class InputParameter
        def self.input(data)
          image_url = data[:url]
          input_id = data[:id]
          metadata = data[:metadata]
          concepts = data[:concepts]

          if image_url.nil? || image_url == ""
            raise ArgumentError, 'Image URL cannot contain nil or be empty'
          end

          input_param = {
            data: {
              image: {
                url: image_url
              }
            }
          }

          # If no ID is supplied, one will be created
          if !input_id.nil?
            input_param[:id] = input_id
          end

          if concepts
            if concepts.is_a?(Array)
              input_param[:data][:concepts] = []
              concepts.each do |concept|
                if concept.is_a?(String)
                  concept = { id: concept, value: true }
                end
                input_param[:data][:concepts] << concept
              end
            else
              raise ArgumentError, 'Concepts must be an Array of Strings or Hashes'
            end
          end

          if metadata
            if metadata.is_a?(Hash)
              input_param[:data][:metadata] = metadata
            else
              raise ArgumentError, 'Metadata must be a Hash'
            end
          end

          return input_param
        end
      end

    end
  end
end
