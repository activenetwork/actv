require 'spec_helper'

describe ACTV::Client do
  let(:client){ ACTV::Client.new }

  describe "#video" do
    before do
      stub_get("/v2/assets/valid_video.json").
        to_return(body: fixture("valid_video.json"), headers: {content_type: "application/json; charset=utf-8"})
    end
    let(:video){ client.video("valid_video") }

    context "with a valid video ID passed" do

      it "should return the correct type" do
        expect(video.type).to eq("video/mp4")
      end

      it "should return the correct source" do
        expect(video.source).to eq("https://rodale.videodownload.worldnow.com/RODALE_2505201618134176078AA.mp4")
      end
    end
  end

  describe "#videos" do
    context "performs a video search with no results" do

      before do
        stub_get("/v2/search.json?query=test&category=videos").
          to_return(body: fixture("valid_search_no_results.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      let(:search_results){ client.videos('test') }

      it 'returns an empty array of assets in results' do
        expect(search_results.results.size).to eq(0)
      end
    end

    context "performs a search with results" do
      before do
        stub_get("/v2/search.json?query=running&category=videos").
          to_return(body: fixture("valid_search.json"), headers: {content_type: "application/json; charset=utf-8"})
      end
      let(:search_results){ client.videos('running') }

      it 'returns the correct array of assets in the results' do
        expect(search_results.results.first.assetName).to eq('Running 5K')
        expect(search_results.results.size).to eq(5)
      end
    end
  end
end