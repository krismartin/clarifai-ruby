module Clarifai
  class Client
    # Defines methods related to input management
    module Input

      # Creates an input using a publicly accessible URL
      # @param [String] image_url publicly accessible image URL to be indexed
      # @option options [String] :id
      # @option options [Array] :concepts
      # @option options [Hash] :metadata
      def create_input(image_url, input_params={})
        if image_url.nil? || image_url.empty?
          raise ArgumentError, 'Image URL cannot contain nil or be empty'
        end

        params = {
          data: {
            image: { url: image_url }
          }
        }

        input_id = input_params[:id]
        concepts = input_params[:concepts]
        metadata = input_params[:metadata]

        # If no ID is supplied, one will be created
        if !input_id.nil? && !input_id.empty?
          params[:id] = input_id
        end

        if concepts
          if concepts.is_a?(Array)
            params[:data][:concepts] = []
            concepts.each do |concept|
              if concept.is_a?(String)
                concept = { id: concept, value: true }
              end
              params[:data][:concepts] << concept
            end
          else
            raise ArgumentError, 'Concepts must be an Array of Strings or Hashes'
          end
        end

        if metadata
          if metadata.is_a?(Hash)
            params[:data][:metadata] = metadata
          else
            raise ArgumentError, 'Metadata must be a Hash'
          end
        end

        params = { inputs: [params] }

        return post("inputs", params.to_json, params_encoder, encode_json=true)
      end

      # Retrieves an input by ID
      # @param [String] input_id Input ID
      def get_input(input_id)
        if input_id.nil? || input_id.empty?
          raise ArgumentError, 'Input ID cannot contain nil or be empty'
        end
        return get("inputs/#{input_id}", {}, params_encoder, encode_json=true)
      end

      # Deletes an input by ID
      # @param [String] input_id Input ID
      def delete_input(input_id)
        if input_id.nil? || input_id.empty?
          raise ArgumentError, 'Input ID cannot contain nil or be empty'
        end
        return delete("inputs/#{input_id}", {}, params_encoder, encode_json=true)
      end

    end
  end
end
