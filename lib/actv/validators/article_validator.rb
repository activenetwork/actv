require 'actv/validators/asset_validator'
module ACTV
  class ArticleValidator < AssetValidator
    def valid?
      category_is?('articles') || taxonomy_has?('articles')
    end
  end
end
