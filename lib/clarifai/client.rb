module Clarifai
  # Wrapper for the Clarifai API
  #
  class Client < API
    Dir[File.expand_path('../client/*.rb', __FILE__)].each{|f| require f}
  end
end
