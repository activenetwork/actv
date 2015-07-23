require 'actv/validators/asset_validator'
module ACTV
  class AuthorValidator < AssetValidator
    def valid?
      category_is?('author') || taxonomy_has?('author')
    end
  end
end
