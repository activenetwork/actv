module ACTV
  class Quiz < Asset
    def self.valid? response
      ACTV::QuizValidator.new(response).valid?
    end

    def questions
      @questions ||= child_assets_filtered_by_category 'question'
    end

    def outcomes
      @outcomes ||= child_assets_filtered_by_category 'outcome'
    end
  end
end
