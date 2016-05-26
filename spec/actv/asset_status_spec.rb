require 'spec_helper'

describe ACTV::AssetStatus do

  describe "#==" do
    it "return true when objects IDs are the same" do
      asset = ACTV::AssetStatus.new(assetStatusId: 1, assetStatusName: "Status 1")
      other = ACTV::AssetStatus.new(assetStatusId: 1, assetStatusName: "Status 2")
      (asset == other).should be_true
    end

    it "return false when objects IDs are different" do
      asset = ACTV::AssetStatus.new(assetStatusId: 1)
      other = ACTV::AssetStatus.new(assetStatusId: 2)
      (asset == other).should be_false
    end

    it "return false when classes are different" do
      asset = ACTV::AssetStatus.new(assetStatusId: 1)
      other = ACTV::Identity.new(id: 1)
      (asset == other).should be_false
    end
  end


  describe '#visible?' do
    it 'returns true when status assetStatusId is 2' do
      asset = ACTV::AssetStatus.new(assetStatusId: 2, assetStatusName: "VISIBLE")
      expect(asset.visible?).to be_true
    end

    it 'returns false when status assetStatusId is not 2' do
      asset = ACTV::AssetStatus.new(assetStatusId: 1, assetStatusName: "INVISIBLE")
      expect(asset.visible?).to be_false
    end
  end
end