require File.expand_path('../clarifai/configuration', __FILE__)
require File.expand_path('../clarifai/api', __FILE__)
require File.expand_path('../clarifai/client', __FILE__)

module Clarifai
  extend Configuration

  # Alias for Clarifai::Client.new
  #
  # @return [Clarifai::Client]
  def self.client(options={})
    Clarifai::Client.new(options)
  end
end
