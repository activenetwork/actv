require "spec_helper"

describe ACTV::QuizAnswer do
  before do
    stub_post("/v2/assets.json").with(:body => {"id"=>"valid_answer"}).
      to_return(body: fixture("valid_answer.json"))

    stub_post("/v2/assets.json").with(:body => {"id"=>"04745751-2e92-4904-a126-09e516d9d661"}).
      to_return(body: fixture("valid_outcome.json"))
  end

  subject(:answer) { ACTV.asset('valid_answer').first }

  describe '#outcome' do
    subject(:outcome) { answer.outcome }
    context 'when there is an outcome' do
      it 'returns an outcome asset' do
        expect(answer.outcome.id).to eq answer.references[0].id
      end
    end

    context 'when there is not an outcome' do
      before do
        answer.stub(:references) { [] }
      end

      it { should be_nil }
    end

  end
end
