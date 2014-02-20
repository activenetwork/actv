require 'spec_helper'

describe ACTV::Client do
  before do
    @client = ACTV::Client.new
  end

  describe "#asset_stats" do
    context "when we have a guid" do
      before do
        stub_get("/v2/assets/286F5731-9800-4C6E-ADD5-0E3B72392CA7/stats").
          to_return(:status => 200, :body => '{"updatedAt":"2014-02-07 00:50:02","pageViews":1,"assetGuid":"286F5731-9800-4C6E-ADD5-0E3B72392CA7"}', :headers => {})
      end
      it "returns stats for an asset" do
        asset_stats = @client.asset_stats("286F5731-9800-4C6E-ADD5-0E3B72392CA7")
        asset_stats.page_views.should == 1
        asset_stats.asset_guid.should == "286F5731-9800-4C6E-ADD5-0E3B72392CA7"
      end
    end
    context "when nil is passed" do
      before do
        stub_get("/v2/assets/stats").
          to_return(:status => 200, :body => '{"error":{"message":"Sorry, that does not exist."}}', :headers => {})
      end
      it "returns 0 page views" do
        asset_stats = @client.asset_stats(nil)
        asset_stats.page_views.should == 0
        asset_stats.asset_guid.should be_nil
        asset_stats.updated_at.should be_nil
      end
    end
  end
end
