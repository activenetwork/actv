module ACTV
  class QuizAnswer < Asset
    def self.valid? response
      ACTV::QuizAnswerValidator.new(response).valid?
    end

    def outcome
      @outcome ||= begin
        reference_id = references.find do |reference|
          reference.type.downcase == 'outcome'
        end

        ACTV.asset(reference_id.id).first if reference_id
      end
    end
  end
end
