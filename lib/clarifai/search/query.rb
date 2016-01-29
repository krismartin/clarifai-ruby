module Clarifai
  module Search
    class Query

      VALID_SEARCH_QUERIES = [:tags, :query_string, :bool_query, :namespace, :document_ids, :image_urls, :size, :start, :per_page, :page]
      DEFAULT_PER_PAGE = 50
      DEFAULT_PAGE = 0
      attr_accessor :query, :page, :per_page

      def initialize(args)
        valid_args?(args)

        self.page = args[:page] || args[:start]
        self.per_page = args[:per_page] || args[:size]

        self.query = {}
        self.query[:bool] = { must: [] } if multi_search_queries?(args)

        construct_tags_query(args[:tags], args[:namespace]) if (!args[:tags].nil? && !args[:tags].empty?)
        construct_query_string_query(args[:query_string]) if (!args[:query_string].nil? && !args[:query_string].empty?)
        construct_similar_urls_query(args[:image_urls]) if (!args[:image_urls].nil? && !args[:image_urls].empty?)
        construct_similar_items_query(args[:document_ids]) if (!args[:document_ids].nil? && !args[:document_ids].empty?)
        construct_bool_query(args[:bool_query]) if (!args[:bool_query].nil? && !args[:bool_query].empty?)

        if (self.query.has_key?(:bool) && self.query[:bool].is_a?(Hash) && self.query[:bool][:must].is_a?(Array))
          self.query[:bool][:must].flatten!
        end
      end

      def valid_args?(args)
        args.keys.each do |query|
          raise ArgumentError.new("Invalid search query '#{query}'") if !VALID_SEARCH_QUERIES.include? query
        end

        if args.key?(:bool_query) && ![:tags, :query_string, :document_ids, :image_urls].any? {|k| args.key?(k)}
          raise ArgumentError.new("You must specify at least one search criteria ('query_string', 'tags', 'image_urls', 'document_ids') with 'bool_query'")
        end
      end

      def page=(val)
        instance_variable_set("@page", val || DEFAULT_PAGE)
      end

      def per_page=(val)
        instance_variable_set("@per_page", val || DEFAULT_PER_PAGE)
      end

      def multi_search_queries?(args)
        ([:query_string, :tags, :bool_query, :document_ids, :image_urls] & args.keys).count > 1
      end

      def construct_tags_query(tags, namespace=nil)
        if self.query.has_key? :bool
          self.query[:bool][:must] << query_tags(tags, namespace)
        else
          self.query = query_tags(tags, namespace)
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

      def construct_bool_query(bool_query)
        if bool_query.has_key?(:must)
          self.query[:bool][:must] << bool_queries(bool_query[:must])
        end

        if bool_query.has_key?(:must_not)
          self.query[:bool][:must] << {
            bool: {
              must_not: bool_queries(bool_query[:must_not])
            }
          }
        end
      end

      def query_tags(tags, namespace=nil)
        query = {}
        if tags.is_a? Array
          query[:tags] = tags
        elsif tags.is_a? Hash
          query[:tags] = { tags: tags }
          query[:tags][:namespace] = namespace if namespace
        elsif tags.is_a? String
          query[:tags] = [tags]
        end
        return query
      end

      def bool_queries(bool_query)
        terms = []
        bool_query.each do |key, value|
          terms << {
            term: { key => value }
          }
        end
        return terms
      end

    end
  end
end
