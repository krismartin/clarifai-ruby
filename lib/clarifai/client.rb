module Clarifai
  # Wrapper for the Clarifai V2 API
  #
  # @note All methods have been separated into modules and follow the same grouping used in https://developer-preview.clarifai.com/guide/
  class Client < API
    Dir[File.expand_path('../client/*.rb', __FILE__)].each{|f| require f}

    include Clarifai::Client::Input
    include Clarifai::Client::Concept
    include Clarifai::Client::InputMetadata
    include Clarifai::Client::Search
  end
end
