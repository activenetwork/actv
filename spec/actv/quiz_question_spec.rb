require "spec_helper"

describe ACTV::QuizQuestion do
  let(:asset_categories) { [ { category: { categoryName: "Question", categoryTaxonomy: "Creative Work:Quiz:Question" } } ] }
  let(:response) { { body: { assetGuid: 1, assetCategories: asset_categories } } }
  subject(:question) { ACTV::Asset.from_response response }

  describe '#answers' do
    subject(:answers) { question.answers }
    context 'when there are answer assets' do
      it 'returns an array of quiz answers' do
        answer = double(:answer, assetGuid: 123)
        allow(answer).to receive(:category_is?).with('answer') { true }
        not_answer = double(:not_answer, assetGuid: 234)
        allow(not_answer).to receive(:category_is?).with('answer') { false }
        components = [answer, not_answer]
        allow(question).to receive(:components) { components }
        allow(ACTV).to receive(:asset) { components }

        expect(answers).to eq [answer]
      end
    end

    context 'when there are not answer assets' do
      it 'should be empty' do
        allow(question).to receive(:components) { [] }
        expect(answers).to eq []
      end
    end
  end
end
