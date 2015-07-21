require "spec_helper"
describe ACTV::Quiz do
  let(:asset_categories) { [ { category: { categoryName: "Quiz", categoryTaxonomy: "Creative Work:Quiz" } } ] }
  let(:response) { { body: { assetGuid: 1, assetCategories: asset_categories } } }
  subject(:quiz) { ACTV::Asset.from_response response }

  describe '#questions' do
    subject(:questions) { quiz.questions }
    context 'when there are question assets' do
      it 'returns an array of quiz questions' do
        question = double(:question)
        allow(question).to receive(:category_is?).with('question') { true }
        not_question = double(:not_question)
        allow(not_question).to receive(:category_is?).with('question') { false }
        components = [double(full_asset:question), double(full_asset:not_question)]
        allow(quiz).to receive(:components) { components }

        expect(questions).to eq [question]
      end
    end
    context 'when there are not question assets' do
      it { should be_empty }
    end
  end

  describe '#outcomes' do
    subject(:outcomes) { quiz.outcomes }
    context 'when there are outcome assets' do
      it 'returns an array of quiz outcomes' do
        outcome = double(:outcome)
        allow(outcome).to receive(:category_is?).with('outcome') { true }
        not_outcome = double(:not_outcome)
        allow(not_outcome).to receive(:category_is?).with('outcome') { false }
        components = [double(full_asset:outcome), double(full_asset:not_outcome)]
        allow(quiz).to receive(:components) { components }

        expect(outcomes).to eq [outcome]
      end
    end
    context 'when there are no outcome assets' do
      it { should be_empty }
    end
  end
end
