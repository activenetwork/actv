module ACTV
  class AssetReference < Base
    def id
      @attrs[:referenceAsset][:assetGuid]
    end

    def type
      @attrs[:referenceType][:referenceTypeName]
    end

    def full_asset
      ACTV.asset(id).first
    end
  end
end
