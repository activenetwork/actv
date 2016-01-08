module ACTV
  class Quiz < Asset
    include Authorable

    def self.valid? response
      ACTV::QuizValidator.new(response).valid?
    end

    def questions
      @questions ||= child_assets_filtered_by_category 'question'
    end

    def outcomes
      @outcomes ||= child_assets_filtered_by_category 'outcome'
    end

    def find_outcome_by_id guid
      outcomes.find do |outcome|
        outcome.assetGuid == guid
      end
    end
  end
end
