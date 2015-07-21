require "spec_helper"
describe ACTV::QuizQuestion do
  let(:asset_categories) { [ { category: { categoryName: "Question", categoryTaxonomy: "Creative Work:Quiz:Question" } } ] }
  let(:response) { { body: { assetGuid: 1, assetCategories: asset_categories } } }
  subject(:questions) { ACTV::Asset.from_response response }

  describe '#answers' do
    subject(:answers) { questions.answers }
    context 'when there are answer assets' do
      it 'returns an array of quiz answers' do
        answer = double(:answer)
        allow(answer).to receive(:category_is?).with('answer') { true }
        not_answer = double(:not_answer)
        allow(not_answer).to receive(:category_is?).with('answer') { false }
        components = [double(full_asset:answer), double(full_asset:not_answer)]
        allow(questions).to receive(:components) { components }

        expect(answers).to eq [answer]
      end
    end
    context 'when there are not answer assets' do
      it { should be_empty }
    end
  end
end
