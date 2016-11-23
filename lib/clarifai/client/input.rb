module Clarifai
  class Client
    # Defines methods related to input management
    module Input

      # Creates an input using a publicly accessible URL
      def add_input(image_url, input_params={})
        if image_url.nil? || image_url.empty?
          raise ArgumentError.new('Image URL cannot contain nil or be empty')
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
            raise ArgumentError.new('Concepts must be an Array of Strings or Hashes')
          end
        end

        if metadata
          if metadata.is_a?(Hash)
            params[:data][:metadata] = metadata
          else
            raise ArgumentError.new('Metadata must be a Hash')
          end
        end

        params = { inputs: [params] }

        return post("inputs", params.to_json, params_encoder, encode_json=true)
      end

      def get_input(input_id)
        if input_id.nil? || input_id.empty?
          raise ArgumentError.new('Input ID cannot contain nil or be empty')
        end
        return get("inputs/#{input_id}", {}, params_encoder, encode_json=true)
      end

      def delete_input(input_id)
        if input_id.nil? || input_id.empty?
          raise ArgumentError.new('Input ID cannot contain nil or be empty')
        end
        return delete("inputs/#{input_id}", {}, params_encoder, encode_json=true)
      end

    end
  end
end
