require 'spec_helper'

describe ACTV::AssetComponent do

  let(:asset_guid) { "6d92a2db-7ea5-4dfb-90e7-2b7d4dc839ae" }
  subject { ACTV::AssetComponent.new asset_guid: asset_guid }

  describe "#prices" do
    before(:each) do
      stub_request(:post, "http://api.amp.active.com/v2/assets.json").
        to_return(body: fixture("valid_component_asset.json"), headers: { content_type: "application/json; charset=utf-8" })
    end

    it 'returns the prices associated with the component' do
      expect(subject.prices.first).to be_an(ACTV::AssetPrice)
    end
  end

end
