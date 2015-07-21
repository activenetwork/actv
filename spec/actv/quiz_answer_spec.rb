require "spec_helper"
describe ACTV::QuizAnswer do
  let(:asset_categories) { [ { category: { categoryName: "Answer", categoryTaxonomy: "Creative Work:Quiz:Question:Answer" } } ] }
  let(:response) { { body: { assetGuid: 1, assetCategories: asset_categories } } }
  subject(:answer) { ACTV::Asset.from_response response }

  describe '#outcome' do
    subject(:outcome) { answer.outcome }
    context 'when there is an outcome' do
      it 'returns an outcome asset' do
        outcome_asset = double :outcome
        references = [double(type:'outcome',full_asset:outcome_asset), double(type:'not_outcome')]
        allow(answer).to receive(:references) { references }

        expect(outcome).to eq outcome_asset
      end
    end
    context 'when there is not an outcome' do
      it { should be_nil }
    end
  end
end
