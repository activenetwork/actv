require 'spec_helper'
describe ACTV::AssetValidator do
  describe '#valid?' do
    let(:response) { { assetGuid: 1, assetCategories: [] } }
    subject(:validator) { ACTV::AssetValidator.new(response).valid? }
    it { should be_true }
  end
end
