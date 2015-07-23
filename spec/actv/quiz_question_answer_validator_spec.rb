require 'spec_helper'

describe ACTV::QuizQuestionAnswerValidator do
  let(:asset_categories) { [] }
  let(:response) { { assetGuid: 1, assetCategories: asset_categories } }
  subject(:validator) { ACTV::QuizQuestionAnswerValidator.new(response).valid? }

  describe '#valid?' do
    context 'when the response is valid' do
      let(:asset_categories) { [ { category: { categoryName: "Answer", categoryTaxonomy: "Creative Work:Quiz:Question:Answer" } } ] }
      it { should be_true }
    end
    context 'when the response is not valid' do
      it { should be_false }
    end
  end
end
