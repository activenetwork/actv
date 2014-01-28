require 'spec_helper'

describe ACTV::Client do

  before do
    @client = ACTV::Client.new
  end

  describe "#asset" do
    context "with a valid asset ID passed" do
      before do
        stub_get("/v2/assets/valid_asset.json").
          to_return(body: fixture("valid_asset.json"), headers: { content_type: "application/json; charset=utf-8" })

        @asset = @client.asset("valid_asset")[0]
      end

      it "requests the correct asset" do
        a_get("/v2/assets/valid_asset.json").should have_been_made
      end

      it "returns the correct place" do
        @asset.place.name.should eq 'Kingwood Park New Jersey'
      end

      it "returns the correct description" do
        @asset.descriptions.size.should eq 1
        @asset.descriptions.first.description.should eq 'The Run Daddy Run Event is the HCM Foundation way to bring the community together on Fathers Day Weekend to celebrate Fathers and their families.  100% of the proceeds will go to HCM service & scholarship programs.'
      end

      it "returns the correct status" do
        @asset.status.name.should eq 'VISIBLE'
      end

      it "returns the correct legacy data" do
        @asset.legacy_data.online_registration?.should eq "true"
      end

      it "returns the correct asset channel" do
        @asset.channels.size.should eq 2
        @asset.channels.first.sequence.should eq "1"
      end

      it "returns the correct asset component" do
        @asset.components.size.should eq 2
        @asset.components.first.asset_guid.should eq "63e030f3-3df4-402c-9617-d37f6fb2c11b"
      end

      it "returns the correct asset prices" do
        @asset.prices.size.should eq 1
        @asset.prices.first.amount.should eq "10"
      end

      it "returns the correct asset topic" do
        @asset.topics.size.should eq 1
        @asset.topics.first.sequence.should eq "3"
        @asset.topics.first.topic.should be_a ACTV::Topic
        @asset.topics.first.topic.name.should eq "Duathlon"
        @asset.topics.first.topic.taxonomy.should eq "Endurance/Duathlon"
      end
    end
  end

  describe "#asset_by_path" do
    context "with a valid url passed" do
      before do
        @seo_url = "http://www.active.com/san-francisco-ca/running/crazy-eight-fall-2013"
        @seo_url_md5 = Digest::MD5.hexdigest(@seo_url )

        stub_get("/v2/seourls/#{@seo_url_md5}?load_asset=true").
          to_return(body: fixture("valid_asset.json"), headers: { content_type: "application/json; charset=utf-8" })

        @asset = @client.find_asset_by_url(@seo_url)
      end

      it "returns the correct url" do
        @asset.seo_url.should eq @seo_url
      end

      it "returns the correct status" do
        @asset.status.name.should eq 'VISIBLE'
      end

    end
  end

end