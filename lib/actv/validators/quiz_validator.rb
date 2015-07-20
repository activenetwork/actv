require 'actv/validators/asset_validator'
module ACTV
  class QuizValidator < AssetValidator
    def valid?
      category_is?('quiz')
    end
  end
end
