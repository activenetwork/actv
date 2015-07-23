require 'actv/validators/asset_validator'
module ACTV
  class EventValidator < AssetValidator
    def valid?
      category_is?('event') || taxonomy_has?('event')
    end
  end
end
