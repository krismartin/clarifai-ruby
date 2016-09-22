require 'spec_helper'

describe Clarifai::Search::Query do

  it "cannot be created with no arguments" do
    err = ->{ Clarifai::Search::Query.new() }.must_raise ArgumentError
  end

  it "cannot be created with invalid arguments" do
    err = ->{ Clarifai::Search::Query.new(tag: "dog") }.must_raise ArgumentError
  end

  describe "given an array of tags" do

    it "should set the tags property" do
      search_query = Clarifai::Search::Query.new(tags: ["dog", "puppy"])
      search_query.query[:tags].must_equal ["dog", "puppy"]
    end

  end

  describe "given an hash of tags" do

    it "should set the tags property" do
      search_query = Clarifai::Search::Query.new(tags: { "dog" => 1.0, "puppy" => 1.0 })
      search_query.query[:tags][:tags].wont_be_nil
      search_query.query[:tags][:tags].keys.sort.must_equal ["dog", "puppy"].sort
    end

    describe "with namespace" do

      it "should set the namespace property" do
        search_query = Clarifai::Search::Query.new(tags: { "dog" => 1.0, "puppy" => 1.0 }, namespace: "*")
        search_query.query[:tags][:tags].wont_be_nil
        search_query.query[:tags][:tags].keys.sort.must_equal ["dog", "puppy"].sort
        search_query.query[:tags][:namespace].must_equal "*"
      end

    end

  end

  describe "given a single tag" do

    it "should set the tags property" do
      search_query = Clarifai::Search::Query.new(tags: "dog")
      search_query.query[:tags].must_equal ["dog"]
    end

  end

  describe "given a query_string (keyword)" do

    it "should set the query_string property" do
      search_query = Clarifai::Search::Query.new(query_string: "dog puppy")
      search_query.query[:query_string].must_equal "dog puppy"
    end

  end

  describe "given an array of image urls" do

    it "should set the similar_urls property" do
      search_query = Clarifai::Search::Query.new(image_urls: ["http://farm3.staticflickr.com/2752/4425027236_685ee5fa35_b.jpg", "https://farm3.staticflickr.com/2159/1821846921_94856d4d76_b.jpg"])
      search_query.query[:similar_urls].must_equal ["http://farm3.staticflickr.com/2752/4425027236_685ee5fa35_b.jpg", "https://farm3.staticflickr.com/2159/1821846921_94856d4d76_b.jpg"]
    end

  end

  describe "given a single image url" do

    it "should set the similar_urls property" do
      search_query = Clarifai::Search::Query.new(image_urls: "http://farm3.staticflickr.com/2752/4425027236_685ee5fa35_b.jpg")
      search_query.query[:similar_urls].must_equal ["http://farm3.staticflickr.com/2752/4425027236_685ee5fa35_b.jpg"]
    end

  end

  describe "given an array of document ids" do

    it "should set the similar_items property" do
      search_query = Clarifai::Search::Query.new(document_ids: ["document-1", "document-2"])
      search_query.query[:similar_items].must_equal ["document-1", "document-2"]
    end

  end

  describe "given a single document id" do

    it "should set the similar_items property" do
      search_query = Clarifai::Search::Query.new(document_ids: "document-1")
      search_query.query[:similar_items].must_equal ["document-1"]
    end

  end

  describe "given a bool query" do

    it "can be created if given other search criterias" do
      search_query = Clarifai::Search::Query.new(tags: ["dog"], bool_query: { must: { "photographer_id" => "photographer-1" } })
      must_term = search_query.query[:bool][:must].detect{|term| term.keys.first==:term}
      must_term[:term].must_equal({ "photographer_id" => "photographer-1" })
    end

    it "cannot be created without given other search criteria" do
      err = ->{ Clarifai::Search::Query.new(bool_query: { must: { "photographer_id" => "photographer-1" } }) }.must_raise ArgumentError
    end

  end

  describe "given a mixed of bool queries ('must' and 'must_not')" do

    it "should nested the 'must_not' clause" do
      search_query = Clarifai::Search::Query.new(tags: ["dog"], bool_query: { must: { "photographer_id" => "photographer-1" }, must_not: { "orientation" => "landscape" } })
      must_term = search_query.query[:bool][:must].detect{|term| term.keys.first==:term}
      must_not_term = search_query.query[:bool][:must].detect{|term| term.keys.first==:bool}[:bool][:must_not].first
      must_term[:term].must_equal({ "photographer_id" => "photographer-1" })
      must_not_term[:term].must_equal({ "orientation" => "landscape" })
    end

  end

  describe "given a mixed of search criterias" do

    it "should set the 'bool' property" do
      search_query = Clarifai::Search::Query.new(tags: ["dog"], image_urls: ["http://farm3.staticflickr.com/2752/4425027236_685ee5fa35_b.jpg"], )
      search_query.query[:bool].wont_be_nil
    end

    it "should set multiple search criterias" do
      search_query = Clarifai::Search::Query.new(tags: ["dog"], image_urls: ["http://farm3.staticflickr.com/2752/4425027236_685ee5fa35_b.jpg"], bool_query: { must: { "photographer_id" => "photographer-1" } })
      search_query.query[:bool][:must].count.must_equal 3
    end

    describe "given a list of tags and image urls" do

      it "should set the tags and similar_urls criterias" do
        search_query = Clarifai::Search::Query.new(tags: "dog", image_urls: "http://farm3.staticflickr.com/2752/4425027236_685ee5fa35_b.jpg")
        search_criterias = search_query.query[:bool][:must].collect{|criteria| criteria.keys.first}
        search_criterias.must_equal [:tags, :similar_urls]
      end

    end

  end

end
