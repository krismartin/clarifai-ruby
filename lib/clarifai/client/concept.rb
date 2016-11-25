module Clarifai
  class Client
    # Defines methods related to concept management
    module Concept

      # Updates an input with a new concept, or updates a concept value from true/false
      # @param [String] input_id Input ID
      # @param [Array] concepts Array of concepts to be added/updated
      def update_input_concepts(input_id, concepts)
        if input_id.nil? || input_id.empty?
          raise ArgumentError, 'Input ID cannot contain nil or be empty'
        end

        if concepts.nil? || concepts.empty?
          raise ArgumentError, 'Concepts cannot contain nil or be empty'
        end

        if !concepts.is_a?(Array)
          raise ArgumentError, 'Concepts must be an Array'
        end

        params = { concepts: [], action: 'merge_concepts' }
        concepts = [concepts] if concepts.is_a? String
        concepts.each do |concept|
          if concept.is_a?(String)
            concept = { id: concept, value: true }
          end
          params[:concepts] << concept
        end

        return patch("inputs/#{input_id}/data/concepts", params.to_json, params_encoder, encode_json=true)
      end

      # Deletes concepts from an input
      # @param [String] input_id Input ID
      # @param [Array] concepts Array of concepts to be deleted
      def delete_input_concepts(input_id, concepts)
        if input_id.nil? || input_id.empty?
          raise ArgumentError, 'Input ID cannot contain nil or be empty'
        end

        if concepts.nil? || concepts.empty?
          raise ArgumentError, 'Concepts cannot contain nil or be empty'
        end

        if !concepts.is_a?(Array)
          raise ArgumentError, 'Concepts must be an Array or a String'
        end

        params = {
          concepts: concepts.collect{|concept| { id: concept }},
          action: 'delete_concepts'
        }

        return patch("inputs/#{input_id}/data/concepts", params.to_json, params_encoder, encode_json=true)
      end

    end
  end
end
