require 'spec_helper'
describe ACTV::AssetReference do
  let(:asset_guid) { "123" }
  let(:reference_type_name) { "Meow" }
  let(:reference_hash) { {referenceAsset: {assetGuid: asset_guid},
                    referenceType: {referenceTypeName: reference_type_name}} }
  subject(:asset_reference) { ACTV::AssetReference.new reference_hash }

  describe '#id' do
    it 'returns a guid' do
      expect(asset_reference.id).to eq asset_guid
    end
  end

  describe '#type' do
    it 'returns a type' do
      expect(asset_reference.type).to eq reference_type_name
    end
  end
end
