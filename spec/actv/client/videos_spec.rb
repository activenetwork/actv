require 'spec_helper'

describe ACTV::Client do
  before do
    @client = ACTV::Client.new
  end

  describe "#video" do
    context "with a valid video ID passed" do
      before do
        stub_get("/v2/assets/valid_video.json").
        to_return(body: fixture("valid_video.json"), headers: { content_type: "application/json; charset=utf-8" })
        @video = @client.video("valid_video")
      end

      it "requests the correct video" do
        a_get("/v2/assets/valid_video.json").should have_been_made
      end

      it "should return the correct type" do
        @video.type.should eq "video/mp4"
      end

      it "should return the correct source" do
        @video.source.should eq "http://rodale.videodownload.worldnow.com/RODALE_2505201618134176078AA.mp4"
      end
    end
  end

  describe "#videos" do
    context "performs a video search with no results" do
      before do
        stub_get("/v2/search.json?query=test&category=videos").
        to_return(body: fixture("valid_search_no_results.json"), headers: { content_type: "application/json; charset=utf-8" })
      end

      before(:each) do
        @search_results = @client.videos('test')
      end
      
      it 'returns an empty array of assets in results' do
        @search_results.results.size.should eql 0
      end
    end
    
    context "performs a search with results" do
      before do
        stub_get("/v2/search.json?query=running&category=videos").
        to_return(body: fixture("valid_search.json"), headers: { content_type: "application/json; charset=utf-8" })
      end

      before(:each) do
        @search_results = @client.videos('running')
      end
      
      it 'returns the correct array of assets in the results' do
        @search_results.results.first.assetName.should eql 'Running 5K'
        @search_results.results.size.should eql 5
      end
      
     
    end 
  end
end