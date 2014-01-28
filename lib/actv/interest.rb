require 'actv/identity'
require 'actv/asset_tag'
require 'actv/asset_topic'

module ACTV
  class Interest < ACTV::Identity

    attr_reader :interestGuid, :interestName, :urlAdr, :imgUrlAdr, :sorCreatedBy, :sorModifiedBy, :createdDate,
        :modifiedDate, :interestTags, :interestAttributes, :interestTopics, :assetServiceHostName

    alias id interestGuid
    alias name interestName
    alias url urlAdr
    alias image_url imgUrlAdr
    alias created_by sorCreatedBy
    alias modified_by sorModifiedBy
    alias created_date createdDate
    alias modified_date modifiedDate
    alias attributes interestAttributes
    alias asset_service_host_name assetServiceHostName

    def tags
      @asset_tags ||= Array(@attrs[:interestTags]).map do |tag|
        ACTV::AssetTag.new(tag)
      end
    end
    alias interest_tags tags
    alias interestTags tags

    def topics
      @asset_topics ||= Array(@attrs[:interestTopics]).map do |topic|
        ACTV::AssetTopic.new(topic)
      end
    end
    alias interest_topics topics
    alias interestTopics topics

  end
end