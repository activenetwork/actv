require 'spec_helper'

describe ACTV::QuizOutcomeValidator do
  let(:asset_categories) { [] }
  let(:response) { { assetGuid: 1, assetCategories: asset_categories } }
  subject(:validator) { ACTV::QuizOutcomeValidator.new(response).valid? }

  describe '#valid?' do
    context 'when the response is valid' do
      let(:asset_categories) { [ { category: { categoryName: "Outcome", categoryTaxonomy: "Creative Work:Quiz:Outcome" } } ] }
      it { should be_true }
    end
    context 'when the response is not valid' do
      it { should be_false }
    end
  end
end
