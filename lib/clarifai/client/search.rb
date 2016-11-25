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
          }
        }

        if predicted_concepts
          if !predicted_concepts.is_a?(Array)
            raise ArgumentError, ':predicted_concepts must be an Array'
          end

          predicted_concepts.each do |concept|
            params[:query][:ands] << SearchParameter.predicted_concept(concept)
          end
        end

        if user_supplied_concepts
          if !user_supplied_concepts.is_a?(Array)
            raise ArgumentError, ':user_supplied_concepts must be an Array'
          end

          user_supplied_concepts.each do |concept|
            params[:query][:ands] << SearchParameter.user_supplied_concept(concept)
          end
        end

        if metadata
          if !metadata.is_a?(Hash)
            raise ArgumentError, ':metadata must be a Hash'
          end
          params[:query][:ands] << SearchParameter.metadata(metadata)
        end

        puts params

        return post("searches?page=#{page}&per_page=#{per_page}", params.to_json, params_encoder, encode_json=true)
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
