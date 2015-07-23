module ACTV
  class AssetReference < Base
    def id
      @attrs[:referenceAsset][:assetGuid]
    end

    def type
      @attrs[:referenceType][:referenceTypeName]
    end

  end
end
