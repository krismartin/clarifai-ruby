module Clarifai
  class Client
    # Defines methods related to info
    module Info
      # Returns the current api details as well as any usage limits
      #
      # @overload info()
      #   @return [Hashie::Mash] The requested api details.
      #   @example Returns the current api details as well as any usage limits
      #     Clarifai.info()
      # @format :json
      # @authenticated true
      # @see https://developer.clarifai.com/docs/info
      def info()
        response = get("info")
        response
      end
    end
  end
end
