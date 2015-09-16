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

def collection_id
  "clarifai_minitest_#{Time.now.strftime('%Y%m%d')}"
end

def create_collection(client, collection)
  return client.create_collection collection, { max_num_docs: 3000000 }
end

def create_document(client, collection, doc)
  return client.create_document collection, doc[:id], doc[:url], doc[:metadata]
end

def get_document(client, collection, doc_id)
  return client.get_document collection, doc_id
end

def delete_document(client, collection, doc_id)
  return client.delete_document collection, doc_id
end

Minitest.after_run {
  client = Clarifai::Client.new(client_id: client_id, client_secret: client_secret)
  ["collection_test", "collection_test-2", "document_test", "document_metadata_test", "document_annotation_test"].each do |postfix|
    client.delete_collection "#{collection_id}-#{postfix}"
  end
}
