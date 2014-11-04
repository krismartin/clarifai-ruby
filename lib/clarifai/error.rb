module Clarifai
  # Custom error class for rescuing from all Clarifai errors
  class Error < StandardError; end

  # Raised when Clarifai returns the HTTP status code 400
  class BadRequest < Error; end

  # Raised when Clarifai returns the HTTP status code 401
  class Unauthorized < Error; end

  # Raised when Clarifai returns the HTTP status code 500
  class InternalServerError < Error; end
end
