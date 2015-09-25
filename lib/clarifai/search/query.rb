module Clarifai
  module Search
    class Query

      VALID_SEARCH_QUERIES = [:tags, :query_string, :metadata, :document_ids, :image_urls, :size, :start, :per_page, :page]
      DEFAULT_PER_PAGE = 50
      DEFAULT_PAGE = 0
      attr_accessor :query, :page, :per_page

      def initialize(args)
        valid_args?(args)

        self.page = args[:page] || args[:start]
        self.per_page = args[:per_page] || args[:size]

        self.query = {}
        self.query[:bool] = { must: [] } if multi_search_queries?(args)

        construct_tags_query(args[:tags]) if (!args[:tags].nil? && !args[:tags].empty?)
        construct_query_string_query(args[:query_string]) if (!args[:query_string].nil? && !args[:query_string].empty?)
        construct_similar_urls_query(args[:image_urls]) if (!args[:image_urls].nil? && !args[:image_urls].empty?)
        construct_similar_items_query(args[:document_ids]) if (!args[:document_ids].nil? && !args[:document_ids].empty?)
        construct_metadata_query(args[:metadata]) if (!args[:metadata].nil? && !args[:metadata].empty?)

        if (self.query.has_key?(:bool) && self.query[:bool].is_a?(Hash) && self.query[:bool][:must].is_a?(Array))
          self.query[:bool][:must].flatten!
        end
      end

      def valid_args?(args)
        args.keys.each do |query|
          raise ArgumentError.new("Invalid search query '#{query}'") if !VALID_SEARCH_QUERIES.include? query
        end

        if args.key?(:metadata) && ![:tags, :query_string, :document_ids, :image_urls].any? {|k| args.key?(k)}
          raise ArgumentError.new("You must specify at least one search criteria ('query_string', 'tags', 'image_urls', 'document_ids') with 'metadata' filters")
        end
      end

      def page=(val)
        instance_variable_set("@page", val || DEFAULT_PAGE)
      end

      def per_page=(val)
        instance_variable_set("@per_page", val || DEFAULT_PER_PAGE)
      end

      def multi_search_queries?(args)
        ([:tags, :metadata, :document_ids, :image_urls] & args.keys).count > 1
      end

      def construct_tags_query(tags)
        if self.query.has_key? :bool
          self.query[:bool][:must] << query_tags(tags)
        else
          self.query = query_tags(tags)
        end
      end

      def construct_query_string_query(query_string)
        query_string_query = { query_string: query_string }

        if self.query.has_key? :bool
          self.query[:bool][:must] << query_string_query
        else
          self.query = query_string_query
        end
      end

      def construct_similar_urls_query(image_urls)
        image_urls = [image_urls] if image_urls.is_a? String
        similar_url_query = { similar_urls: image_urls }

        if self.query.has_key? :bool
          self.query[:bool][:must] << similar_url_query
        else
          self.query = similar_url_query
        end
      end

      def construct_similar_items_query(document_ids)
        document_ids = [document_ids] if document_ids.is_a? String
        similar_items_query = { similar_items: document_ids }

        if self.query.has_key? :bool
          self.query[:bool][:must] << similar_items_query
        else
          self.query = similar_items_query
        end
      end

      def construct_metadata_query(metadata)
        if self.query.has_key? :bool
          self.query[:bool][:must] << metadata_filters(metadata)
        else
          self.query = metadata_filters(metadata)
        end
      end

      def query_tags(tags)
        query = {}
        if tags.is_a? Array
          query[:tags] = tags
        elsif tags.is_a? Hash
          query[:tags] = { tags: tags }
        elsif tags.is_a? String
          query[:tags] = [tags]
        end
        return query
      end

      def metadata_filters(filters)
        terms = []
        filters.each do |key, value|
          terms << {
            term: { key => value }
          }
        end
        return terms
      end

    end
  end
end
