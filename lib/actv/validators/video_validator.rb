require 'actv/validators/asset_validator'
module ACTV
  class VideoValidator < AssetValidator
    def valid?
      category_is?('videos') || taxonomy_has?('videos')
    end
  end
end
