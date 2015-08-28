require File.expand_path('../clarifai/error', __FILE__)
require File.expand_path('../clarifai/configuration', __FILE__)
require File.expand_path('../clarifai/search/query', __FILE__)
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

  # Delegate to Clarifai::Client
  def self.method_missing(method, *args, &block)
    return super unless client.respond_to?(method)
    client.send(method, *args, &block)
  end

  # Delegate to Clarifai::Client
  def self.respond_to?(method, include_all=false)
    return client.respond_to?(method, include_all) || super
  end
end
