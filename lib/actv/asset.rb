require 'actv/asset_channel'
require 'actv/asset_component'
require 'actv/asset_description'
require 'actv/asset_image'
require 'actv/asset_legacy_data'
require 'actv/asset_price'
require 'actv/asset_reference'
require 'actv/asset_status'
require 'actv/asset_tag'
require 'actv/asset_topic'
require 'actv/asset_seo_url'
require 'actv/identity'
require 'actv/place'
require 'actv/recurrence'
require 'actv/asset_source_system'

module ACTV
  class Asset < ACTV::Identity
    include AssetSourceSystem

    @types = []

    attr_reader :assetGuid, :assetName, :assetDsc, :activityStartDate, :activityStartTime, :activityEndDate, :activityEndTime,
      :homePageUrlAdr, :isRecurring, :contactName, :contactEmailAdr, :contactPhone, :showContact, :publishDate, :createdDate, :modifiedDate,
      :authorName, :is_event, :is_article, :currencyCd, :contactTxt, :regReqMinAge, :regReqMaxAge, :regReqGenderCd

    alias id assetGuid
    alias title assetName
    alias start_date activityStartDate
    alias start_time activityStartTime
    alias end_date activityEndDate
    alias end_time activityEndTime
    alias home_page_url homePageUrlAdr
    alias is_recurring? isRecurring
    alias contact_name contactName
    alias contact_email contactEmailAdr
    alias contact_phone contactPhone
    alias contact_txt contactTxt
    alias show_contact? showContact
    alias published_at publishDate
    alias created_at createdDate
    alias updated_at modifiedDate
    alias author_name authorName
    alias activity_start_date activityStartDate
    alias activity_end_date activityEndDate
    alias currency_code currencyCd
    alias minimum_age regReqMinAge
    alias maximum_age regReqMaxAge
    alias required_gender regReqGenderCd

    def self.inherited base
      @types << base
    end

    def self.types
      @types + Array(self)
    end

    def self.from_response response={}
      AssetFactory.new(response[:body]).asset
    end

    def self.valid? response
      AssetValidator.new(response).valid?
    end

    def endurance_id
      if self.awendurance?
        query_values = Addressable::URI.parse(registrationUrlAdr.to_s).query_values
        query_values ||= {}
        query_values.fetch 'e', nil
      end
    end

    def recurrences
      @recurrences ||= Array(@attrs[:activityRecurrences]).map do | recurrence |
        ACTV::Recurrence.new(recurrence)
      end
    end

    def place
      @place ||= ACTV::Place.new(@attrs[:place]) unless @attrs[:place].nil?
    end

    def place_timezone
      @place_timezone ||= place[:timezone] unless place[:timezone].nil?
    end

    def org_timezone
      @org_timezone ||= @attrs[:localTimeZoneId] unless @attrs[:localTimeZoneId].nil?
    end

    def version
      @asset_version ||= @attrs[:assetVersion] unless @attrs[:assetVersion].nil?
    end

    def descriptions
      @descriptions ||= Array(@attrs[:assetDescriptions]).map do |description|
        ACTV::AssetDescription.new(description)
      end
    end
    alias asset_descriptions descriptions
    alias assetDescriptions descriptions

    def status
      @status ||= ACTV::AssetStatus.new(@attrs[:assetStatus]) unless @attrs[:assetStatus].nil?
    end
    alias asset_status status
    alias assetStatus status

    def visible?
      asset_status.visible?
    end

    def legacy_data
      @legacy_data ||= ACTV::AssetLegacyData.new(@attrs[:assetLegacyData]) unless @attrs[:assetLegacyData].nil?
    end
    alias asset_legacy_data legacy_data
    alias assetLegacyData legacy_data

    def channels
      @asset_channels ||= Array(@attrs[:assetChannels]).map do |channel|
        ACTV::AssetChannel.new(channel)
      end
    end
    alias asset_channels channels
    alias assetChannels channels

    def images
      @images ||= Array(@attrs[:assetImages]).map do |img|
        ACTV::AssetImage.new(img)
      end
    end
    alias asset_images images
    alias assetImages images

    def tags
      @asset_tags ||= Array(@attrs[:assetTags]).map do |tag|
        ACTV::AssetTag.new(tag)
      end
    end
    alias asset_tags tags
    alias assetTags tags

    def components
      @asset_components ||= Array(@attrs[:assetComponents]).map do |component|
        ACTV::AssetComponent.new(component)
      end
    end
    alias asset_components components
    alias assetComponents components

    def prices
      @asset_prices ||= Array(@attrs[:assetPrices]).map do |price|
        ACTV::AssetPrice.new(price)
      end
    end
    alias asset_prices prices
    alias assetPrices prices

    def has_volume_based_price?
      prices.any? { |price| price.volume_pricing? }
    end

    def topics
      @asset_topics ||= Array(@attrs[:assetTopics]).map do |topic|
        ACTV::AssetTopic.new(topic)
      end.sort
    end
    alias asset_topics topics
    alias assetTopics topics

    def seo_urls
      @seo_urls ||= Array(@attrs[:assetSeoUrls]).map do |seo_url|
        ACTV::AssetSeoUrl.new(seo_url)
      end
    end
    alias asset_seo_urls seo_urls
    alias assetSeoUrls seo_urls

    def summary
      @summary ||= description_by_type 'summary'
    end

    def description
      @description ||= description_by_type 'Standard'
    end

    def seo_url(systemName = 'as3')
      seo_url = self.seo_urls.find { |s| s.seoSystemName.downcase == systemName.downcase }
      seo_url.urlAdr unless seo_url.nil?
    end

    def description_by_type(type)
      dsc = self.descriptions.find { |dsc| dsc.type.name.downcase == type.downcase }
      (dsc.description.downcase == 'n/a' ? '' : dsc.description) if dsc
    end

    def image_by_name(name)
      self.images.find { |img| img.name.downcase == name.downcase }
    end

    def tag_by_description(description)
      asset_tag = self.tags.find { |at| at.tag.description.downcase == description.downcase }
      asset_tag.tag.name if asset_tag
    end

    def is_event?
      false
    end

    def is_article?
      false
    end

    def is_video?
      false
    end

    def has_location?
      self.place && place.has_lat_long?
    end

    def evergreen?
      self.evergreenAssetFlag.downcase == 'true' rescue false
    end

    def kids?
      kids_friendly_source_system? && kids_interest?
    end

    def registration_status
      @registration_status ||= nil
    end
    alias reg_status registration_status

    def attributes
      @attributes ||= assetAttributes.sort_by do |attribute|
        attribute[:attribute][:attributeType]
      end.map do |attribute|
        attribute[:attribute][:attributeValue]
      end
    end

    def attribute_paths
      attributes.map do |attribute|
        [sub_topic_path, urlize(attribute)].join "/"
      end
    end

    def meta_interests
      @meta_interests ||= attrs[:assetMetaInterests].sort_by do |interest|
        interest[:sequence]
      end.map do |interest|
        interest[:metaInterest][:metaInterestName]
      end
    end

    def meta_interest_paths
      meta_interests.map do |meta_interest|
        [sub_topic_path, urlize(meta_interest)].join "/"
      end
    end

    def location_path
      @location ||= "#{place.cityName} #{place.stateProvinceCode}".downcase.gsub ' ','-'
    end

    def first_topic
      get_first_topic_taxonomy[0]
    end
    alias topic first_topic

    def first_topic_path
      urlize first_topic
    end

    def first_topic_name
      topics.first.topic.name unless topics.empty?
    end

    def sub_topic
      get_first_topic_taxonomy[1]
    end

    def sub_topic_path
      urlize sub_topic
    end

    def sub_2_topic
      get_first_topic_taxonomy[2]
    end

    def sub_2_topic_path
      urlize "#{sub_topic_path}/#{sub_2_topic}"
    end

    def sub_3_topic
      get_first_topic_taxonomy[3]
    end

    def sub_3_topic_path
      urlize "#{sub_2_topic_path}/#{sub_3_topic}"
    end

    def sub_4_topic
      get_first_topic_taxonomy[4]
    end

    def sub_4_topic_path
      urlize "#{sub_3_topic_path}/#{sub_4_topic}"
    end

    def image_with_placeholder
      if image_path.empty?
        "/images/logo-active-icon-gray.gif"
      else
        image_path
      end
    end

    def image_path
      default_image = 'http://www.active.com/images/events/hotrace.gif'
      image = image_without_placeholder.imageUrlAdr rescue ""

      if image.empty? and (logoUrlAdr && logoUrlAdr != default_image && !(logoUrlAdr =~ URI::regexp).nil?)
        image = logoUrlAdr
      end

      image
    end

    def media_url
      image_without_placeholder.imageUrlAdr rescue ""
    end

    def image
      image_without_placeholder
    end

    def references
      @references ||= Array(@attrs[:assetReferences]).map do |reference|
        ACTV::AssetReference.new reference
      end
    end

    def category_is? name
      @attrs[:assetCategories].any? do |cat|
        cat[:category][:categoryName].downcase == name.downcase
      end
    end

    def organization
      @attrs[:organization] || {}
    end

    private

    def child_assets_filtered_by_category category
      child_assets.select { |child| child.category_is? category }
    end

    def child_assets
      @child_assets ||= if components.any?
                          ACTV.asset components.map(&:assetGuid)
                        else
                          []
                        end
    end

    def image_without_placeholder
      default_image = 'http://www.active.com/images/events/hotrace.gif'
      current_image = nil

      asset_images.each do |i|
        if i.imageUrlAdr.downcase != default_image
          current_image = i
          break
        end
      end

      current_image
    end

    def get_first_topic_taxonomy
      @first_topic_taxonomy ||= assetTopics.first
      if @first_topic_taxonomy
        @first_topic_taxonomy.topic.topicTaxonomy.split '/'
      else
        []
      end
    end

    def urlize str
      if str
        str.downcase.gsub ' ', '-'
      else
        ""
      end
    end

    def kids_interest?
      interests = meta_interests.to_a.map(&:downcase)
      ['kids', 'family'].any? { |tag| interests.include? tag }
    end
  end
end
