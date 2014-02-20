module ACTV
  class AssetStatsResult < Base
    attr_reader :updated_at, :page_views, :asset_guid

    def initialize options
      @updated_at = options[:updatedAt]
      @asset_guid = options[:assetGuid]
      @page_views = options.fetch :pageViews, 0
    end
  end
end
