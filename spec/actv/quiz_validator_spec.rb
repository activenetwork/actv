require 'spec_helper'

describe ACTV::QuizValidator do
  let(:asset_categories) { [] }
  let(:response) { { assetGuid: 1, assetCategories: asset_categories } }
  subject(:validator) { ACTV::QuizValidator.new(response).valid? }

  describe '#valid?' do
    context 'when the response is valid' do
      let(:asset_categories) { [ { category: { categoryName: "Quiz", categoryTaxonomy: "Creative Work:Quiz" } } ] }
      it { should be_true }
    end
    context 'when the response is not valid' do
      it { should be_false }
    end
  end
end
