module ACTV
  class AssetComponent < Base
    attr_reader :assetGuid
    alias asset_guid assetGuid

    def prices
      ACTV.asset(asset_guid).map(&:prices).first
    end

    def full_asset
      ACTV.asset(asset_guid).first
    end
  end
end
