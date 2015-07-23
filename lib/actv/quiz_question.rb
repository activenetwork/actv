module ACTV
  class QuizQuestion < Asset
    def self.valid? response
      ACTV::QuizQuestionValidator.new(response).valid?
    end

    def answers
      @answers ||= child_assets_filtered_by_category 'answer'
    end
  end
end
