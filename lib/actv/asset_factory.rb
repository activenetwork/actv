module ACTV
  class AssetFactory
    attr_reader :response

    def initialize response_body
      @response = response_body
    end

    def asset
      ACTV::Asset.types.each do |type|
        asset = type.new response
        return asset if asset.valid?
      end
      ACTV::Asset.new response
    end
  end
end
