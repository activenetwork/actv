require 'actv/validators/asset_validator'
module ACTV
  class QuizQuestionValidator < AssetValidator
    def valid?
      category_is?('question')
    end
  end
end
