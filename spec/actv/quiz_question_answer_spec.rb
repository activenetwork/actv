require "spec_helper"
describe ACTV::QuizQuestionAnswer do
  let(:asset_categories) { [ { category: { categoryName: "Answer", categoryTaxonomy: "Creative Work:Quiz:Question:Answer" } } ] }
  let(:response) { { body: { assetGuid: 1, assetCategories: asset_categories } } }
  subject(:answer) { ACTV::Asset.from_response response }

  describe '#outcome' do
    subject(:outcome) { answer.outcome }
    context 'when there is an outcome' do
      it 'returns an outcome asset' do
        outcome_asset = double :outcome, id: 1
        references = [double(type:'outcome', id: 1),
                      double(type:'not_outcome', id: 2)]
        allow(answer).to receive(:references) { references }
        allow(ACTV).to receive(:asset).with(outcome_asset.id) { [outcome_asset] }
        expect(outcome.id).to eq outcome_asset.id
      end
    end
    context 'when there is not an outcome' do
      it { should be_nil }
    end
  end
end
