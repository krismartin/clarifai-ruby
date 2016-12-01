module Clarifai
  class Client
    # Defines methods related to searches
    module Search

      # Searches by concepts
      # @option options [Array] :predicted_concepts
      # @option options [Array] :user_supplied_concepts
      # @option options [Hash] :metadata
      def search(options={}, page=1, per_page=20)
        params = {}

        predicted_concepts = options[:predicted_concepts]
        user_supplied_concepts = options[:user_supplied_concepts]
        metadata = options[:metadata]

        params = {
          query: {
            ands: []
          },
          pagination: {
            page: page,
            per_page: per_page
          }
        }

        if predicted_concepts
          raise ArgumentError, ':predicted_concepts must be an Array' if !predicted_concepts.is_a?(Array)
          predicted_concepts.each do |concept|
            params[:query][:ands] << SearchParameter.predicted_concept(concept)
          end
        end

        if user_supplied_concepts
          raise ArgumentError, ':user_supplied_concepts must be an Array' if !user_supplied_concepts.is_a?(Array)
          user_supplied_concepts.each do |concept|
            params[:query][:ands] << SearchParameter.user_supplied_concept(concept)
          end
        end

        if metadata
          raise ArgumentError, ':metadata must be a Hash' if !metadata.is_a?(Hash)
          params[:query][:ands] << SearchParameter.metadata(metadata)
        end

        return post("searches", params.to_json, params_encoder, encode_json=true)
      end

      class SearchParameter
        def self.concept(concept_type, concept)
          key = nil
          case concept_type
          when :predicted
            key = :output
          when :user_supplied
            key = :input
          else
            raise "Unknown concept_type '#{concept_type}'"
          end

          return {
            key => {
              data: {
                concepts: [
                  {
                    name: concept
                  }
                ]
              }
            }
          }
        end

        def self.predicted_concept(concept)
          return self.concept(:predicted, concept)
        end

        def self.user_supplied_concept(concept)
          return self.concept(:user_supplied, concept)
        end

        def self.metadata(metadata)
          return {
            input: {
              data: {
                metadata: metadata
              }
            }
          }
        end
      end

    end
  end
end
