module Clarifai
  class Client
    # Defines methods related to searches
    module Search

      # Search by concepts
      # @param [String] concept_type Concept type to search (:predicted or :user_supplied)
      # @param [Array] concepts Array of concepts
      # @option options [Hash] :metadata Search by custom metadata
      # @option options [Integer] :page Page number
      # @option options [Integer] :per_page Number of records per page
      def search(concept_type, concepts, options={})
        page = options[:page] || 1
        per_page = options[:page] || 50
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

        raise ArgumentError, 'Concepts must be an Array' if !concepts.is_a?(Array)
        concepts.each do |concept|
          case concept_type
          when :predicted
            params[:query][:ands] << SearchParameter.predicted_concept(concept)
          when :user_supplied
            params[:query][:ands] << SearchParameter.user_supplied(concept)
          else
            raise ArgumentError, "Unknown concept type '#{concept_type}'"
          end
        end

        if metadata
          raise ArgumentError, ':metadata must be a Hash' if !metadata.is_a?(Hash)
          params[:query][:ands] << SearchParameter.metadata(metadata)
        end

        return post("searches", params.to_json, params_encoder, encode_json=true)
      end

      # Search by predicted concepts
      # @param [Array] concepts Array of concepts
      # @option options [Hash] :metadata Search by custom metadata
      # @option options [Integer] :page Page number
      # @option options [Integer] :per_page Number of records per page
      def search_by_predicted_concepts(concepts, options={})
        return search(:predicted, concepts, options)
      end

      # Search by user supplied concepts
      # @param [Array] concepts Array of concepts
      # @option options [Hash] :metadata Search by custom metadata
      # @option options [Integer] :page Page number
      # @option options [Integer] :per_page Number of records per page
      def search_by_user_supplied_concepts(concepts, options={})
        return search(:user_supplied, concepts, options)
      end

      # Search by reverse image using image URL or input ID
      # @param [String] image_url_or_input_id Image URL or Input ID
      # @option options [Integer] :page Page number
      # @option options [Integer] :per_page Number of records per page
      def reverse_image_search(image_url_or_input_id, options={})
        page = options[:page] || 1
        per_page = options[:per_page] || 50
        metadata = options[:metadata]

        search_type = (image_url_or_input_id =~ /\A#{URI::regexp}\z/) ? :url : :id

        case search_type
        when :url
          input_param = {
            data: {
              image: {
                url: image_url_or_input_id
              }
            }
          }

        when :id
          input_param = {
            id: image_url_or_input_id,
            data: {
              image: {}
            }
          }

        end

        params = {
          query: {
            ands: [
              output: {
                input: input_param
              }
            ]
          },
          pagination: {
            page: page,
            per_page: per_page
          }
        }

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

        def self.user_supplied(concept)
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
