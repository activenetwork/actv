require 'actv/validators/asset_validator'
module ACTV
  class QuizOutcomeValidator < AssetValidator
    def valid?
      category_is?('outcome')
    end
  end
end
