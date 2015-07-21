module ACTV
  class QuizAnswer < Asset
    def self.valid? response
      ACTV::QuizAnswerValidator.new(response).valid?
    end

    def outcome
      @outcome ||= references.find do |reference|
        reference.type.downcase == 'outcome'
      end
      @outcome.full_asset if @outcome
    end
  end
end
