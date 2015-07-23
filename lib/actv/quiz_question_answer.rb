module ACTV
  class QuizQuestionAnswer < Asset
    def self.valid? response
      ACTV::QuizQuestionAnswerValidator.new(response).valid?
    end

    def outcome
      reference = references.find { |ref| ref.type.downcase == 'outcome' }
      @outcome ||= ACTV.asset(reference.id).first if reference
    end
  end
end
