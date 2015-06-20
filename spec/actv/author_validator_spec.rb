require 'spec_helper'

describe ACTV::AuthorValidator do
  let(:asset_categories) { [] }
  let(:response) { { assetGuid: 1, assetCategories: asset_categories } }
  subject(:validator) { ACTV::AuthorValidator.new(response).valid? }

  describe '#valid?' do
    context 'when the response is valid' do
      context 'because the category name is valid' do
        let(:asset_categories) { [ { category: { categoryName: "Author", categoryTaxonomy: "" } } ] }
        it { should be_true }
      end
      context 'because the category taxonomy is valid' do
        let(:asset_categories) { [ { category: { categoryName: "", categoryTaxonomy: "Person/Author" } } ] }
        it { should be_true }
      end
    end
    context 'when the response is not valid' do
      it { should be_false }
    end
  end
end
