require 'minitest/spec'
require 'minitest/autorun'

require 'faraday'
require 'clarifai'

def client_id
  ENV["CLARIFAI_CLIENT_ID"]
end

def client_secret
  ENV["CLARIFAI_CLIENT_SECRET"]
end

def api_endpoint
  ENV["CLARIFAI_ENDPOINT"] || "https://api.clarifai.com/v2/"
end
