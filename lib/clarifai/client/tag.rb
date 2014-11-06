module Clarifai
  class Client
    # Defines methods related to tagging
    module Tag
      # Tags an image from url
      #
      # @overload tag(url)
      #   @param urls [Array] The urls of the images
      #   @example 1: Tags an image from url
      #     Clarifai.tag("https://farm9.staticflickr.com/8521/8462518619_5eb4e52ede_z.jpg")
      #   @example 2: Tags multiple images from urls
      #     Clarifai.tag(["https://farm9.staticflickr.com/8521/8462518619_5eb4e52ede_z.jpg", "https://farm6.staticflickr.com/5063/5851651730_ee7ebe5d5f_z.jpg"])
      #   @example 3: Tags multiple images from urls and specify a local_id for each image in the request
      #     Clarifai.tag(["https://farm9.staticflickr.com/8521/8462518619_5eb4e52ede_z.jpg", "https://farm6.staticflickr.com/5063/5851651730_ee7ebe5d5f_z.jpg"], local_id: ["8462518619", "5851651730"])
      # @format :json
      # @authenticated true
      # @see https://developer.clarifai.com/docs/tag
      def tag(urls, options={})
        response = post("tag", options.merge(url: urls), Faraday::FlatParamsEncoder)
        response
      end
    end
  end
end
