module Clarifai
  class Client
    # Defines methods related to concept management
    module Concept

      # Updates an input with a new concept, or updates a concept value from true/false
      def update_input_concepts(input_id, concepts)
        if input_id.nil? || input_id.empty?
          raise ArgumentError.new('Input ID cannot contain nil or be empty')
        end

        if concepts.nil? || concepts.empty?
          raise ArgumentError.new('Concepts cannot contain nil or be empty')
        end

        if !concepts.is_a?(Array) && !concepts.is_a?(String)
          raise ArgumentError.new('Concepts must be an Array or a String')
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
      def delete_input_concepts(input_id, concepts)
        if input_id.nil? || input_id.empty?
          raise ArgumentError.new('Input ID cannot contain nil or be empty')
        end

        if concepts.nil? || concepts.empty?
          raise ArgumentError.new('Concepts cannot contain nil or be empty')
        end

        if !concepts.is_a?(Array) && !concepts.is_a?(String)
          raise ArgumentError.new('Concepts must be an Array or a String')
        end

        params = { concepts: [], action: 'delete_concepts' }
        concepts = [concepts] if concepts.is_a? String
        params[:concepts] = concepts.collect{|concept| { id: concept }}

        return patch("inputs/#{input_id}/data/concepts", params.to_json, params_encoder, encode_json=true)
      end

    end
  end
end
