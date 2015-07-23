require 'actv/validators/asset_validator'
module ACTV
  class QuizQuestionAnswerValidator < AssetValidator
    def valid?
      category_is?('answer')
    end
  end
end
