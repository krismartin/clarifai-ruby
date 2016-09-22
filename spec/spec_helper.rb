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
  ENV["CLARIFAI_ENDPOINT"] || "https://api.clarifai.com/v1/"
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

def create_documents(client, collection)
  [
    { id: "image_1", url: "http://farm3.staticflickr.com/2063/5742404359_fce5e850bd_b.jpg", type: "image/jpeg", metadata: { "title" => "Ocean", "photographer_name" => "Evans Dare", "photographer_id" => "photographer_1", "orientation" => "landscape", "license_type" => "royalty_free" } },
    { id: "image_2", url: "http://farm7.staticflickr.com/6021/6004280141_bd421425af_b.jpg", type: "image/jpeg", metadata: { "title" => "Crowd at soccer stadium", "photographer_name" => "Pablo Champlin", "photographer_id" => "photographer_2", "orientation" => "landscape", "license_type" => "royalty_free" } },
    { id: "image_3", url: "http://farm4.staticflickr.com/3720/18644414989_e1c248e0b1_b.jpg", type: "image/jpeg", metadata: { "title" => "NYC Skyline", "photographer_name" => "Israel Bode", "photographer_id" => "photographer_3", "orientation" => "landscape", "license_type" => "rights_managed" } },
    { id: "image_4", url: "http://farm8.staticflickr.com/7391/10398896814_ce60a772c4_b.jpg", type: "image/jpeg", metadata: { "title" => "Yellow Cab, NYC", "photographer_name" => "Israel Bode", "photographer_id" => "photographer_3", "orientation" => "landscape", "license_type" => "royalty_free" } },
    { id: "image_5", url: "http://farm6.staticflickr.com/5068/5689835339_33ac1745ca_b.jpg", type: "image/jpeg", metadata: { "title" => "Telephone Booth", "photographer_name" => "Emmett Kuhlman", "photographer_id" => "photographer_4", "orientation" => "portrait", "license_type" => "royalty_free" } },
    { id: "image_6", url: "http://farm6.staticflickr.com/5323/18223890844_baa427cbbe_b.jpg", type: "image/jpeg", metadata: { "title" => "Sunset, Waikiki Beach", "photographer_name" => "Evelyn Lehner", "photographer_id" => "photographer_5", "orientation" => "landscape", "license_type" => "rights_managed" } },
    { id: "image_7", url: "http://farm5.staticflickr.com/4110/5194747168_daa9bd6f47_b.jpg", type: "image/jpeg", metadata: { "title" => "Taxi in Japan", "photographer_name" => "Robert Wiza", "photographer_id" => "photographer_6", "orientation" => "landscape", "license_type" => "rights_managed" } },
    { id: "image_8", url: "http://farm3.staticflickr.com/2788/4424287937_7fa119b45d_b.jpg", type: "image/jpeg", metadata: { "title" => "Great Ocean Road", "photographer_name" => "Jane Williamson", "photographer_id" => "photographer_7", "orientation" => "landscape", "license_type" => "royalty_free" } },
    { id: "image_9", url: "http://farm3.staticflickr.com/2719/4300373354_a5c867e3b3_b.jpg", type: "image/jpeg", metadata: { "title" => "Puppy Pug", "photographer_name" => "Sam Smith", "photographer_id" => "photographer_8", "orientation" => "landscape", "license_type" => "royalty_free" } },
    { id: "image_10", url: "http://farm4.staticflickr.com/3343/3558798075_5542d0b1fc_b.jpg", type: "image/jpeg", metadata: { "title" => "Elephant", "photographer_name" => "Sam Smith", "photographer_id" => "photographer_8", "orientation" => "landscape", "license_type" => "royalty_free" } }
  ].each do |doc|
    create_document(client, collection, doc)
  end
end

def get_document(client, collection, doc_id)
  return client.get_document collection, doc_id
end

def delete_document(client, collection, doc_id)
  return client.delete_document collection, doc_id
end

Minitest.after_run {
  puts "Using API endpoint: #{api_endpoint}"
  client = Clarifai::Client.new(client_id: client_id, client_secret: client_secret)
  ["collection_test", "collection_test-2", "document_test", "document_metadata_test", "document_annotation_test", "search_test"].each do |postfix|
    client.delete_collection "#{collection_id}-#{postfix}"
  end
}
