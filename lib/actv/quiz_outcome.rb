module ACTV
  class QuizOutcome < Asset
    def self.valid? response
      ACTV::QuizOutcomeValidator.new(response).valid?
    end
  end
end
