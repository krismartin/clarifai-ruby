require 'minitest/spec'
require 'minitest/autorun'

require 'faraday'
require 'clarifai'
require 'securerandom'

def api_key
  ENV["CLARIFAI_API_KEY"]
end

def client_id
  ENV["CLARIFAI_CLIENT_ID"]
end

def client_secret
  ENV["CLARIFAI_CLIENT_SECRET"]
end

def api_endpoint
  ENV["CLARIFAI_ENDPOINT"] || "https://api.clarifai.com/v2/"
end
