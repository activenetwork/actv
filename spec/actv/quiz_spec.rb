require "spec_helper"

describe ACTV::Quiz do
  let(:asset_categories) { [ { category: { categoryName: "Quiz", categoryTaxonomy: "Creative Work:Quiz" } } ] }
  let(:response) { { body: { assetGuid: 1, assetCategories: asset_categories } } }
  subject(:quiz) { ACTV::Asset.from_response response }

  describe '#questions' do
    subject(:questions) { quiz.questions }

    context 'when there are question assets' do
      it 'returns an array of quiz questions' do
        question = double(:question, assetGuid: 123)
        allow(question).to receive(:category_is?).with('question') { true }
        not_question = double(:not_question, assetGuid: 234)
        allow(not_question).to receive(:category_is?).with('question') { false }
        components = [question, not_question]
        allow(quiz).to receive(:components) { components }
        allow(ACTV).to receive(:asset) { components }

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
        outcome = double(:outcome, assetGuid: 123)
        allow(outcome).to receive(:category_is?).with('outcome') { true }
        not_outcome = double(:not_outcome, assetGuid: 234)
        allow(not_outcome).to receive(:category_is?).with('outcome') { false }
        components = [outcome, not_outcome]
        allow(quiz).to receive(:components) { components }
        allow(ACTV).to receive(:asset) { components }

        expect(outcomes).to eq [outcome]
      end
    end

    context 'when there are no outcome assets' do
      it { should be_empty }
    end
  end

  describe '#find_outcome_by_id' do
    subject(:outcome) { quiz.find_outcome_by_id "123" }

    context 'when the outcome exists' do
      it 'returns an outcome' do
        outcome_a = double(:outcome_a, assetGuid: "123")
        outcome_b = double(:outcome_b, assetGuid: "234")
        outcomes = [outcome_a, outcome_b]
        allow(quiz).to receive(:outcomes) { outcomes }

        expect(outcome).to eq outcome_a
      end
    end
    context 'when the outcome does not exist' do
      it { should be_nil }
    end
  end
end
