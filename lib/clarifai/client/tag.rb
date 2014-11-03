module Clarifai
  class Client
    # Defines methods related to tagging
    module Tag
      # Tags an image from url
      #
      # @overload tag(url)
      #   @param url [Array] The urls of the images
      #   @example FIXME
      #     Clarifai.tag("https://farm9.staticflickr.com/8521/8462518619_5eb4e52ede_z.jpg")
      #     Clarifai.tag(["https://farm9.staticflickr.com/8521/8462518619_5eb4e52ede_z.jpg", "https://farm6.staticflickr.com/5063/5851651730_ee7ebe5d5f_z.jpg"])
      # @format :json
      # @see https://developer.clarifai.com/docs/tag
      def tag(urls, options={})
        response = post("tag", options.merge(url: urls), Faraday::FlatParamsEncoder)
        response
      end
    end
  end
end
