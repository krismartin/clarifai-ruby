module Clarifai
  class Client
    # Defines methods related to tagging
    module Tag
      # Tags an image from url
      #
      # @overload tag(url)
      #   @param url [String] The url of the image
      #   @example FIXME
      #     Clarifai.tag("http://unsplash.imgix.net/33/YOfYx7zhTvYBGYs6g83s_IMG_8643.jpg")
      # @format :json
      # @see https://developer.clarifai.com/docs/tag
      def tag(url, options={})
        response = post("tag", options.merge(url: url))
        response
      end
    end
  end
end
