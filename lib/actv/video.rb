require 'actv/asset'

module ACTV
  class Video < Asset
    attr_reader :sorCreateDtm, :urlAdr
    alias publish_date sorCreateDtm
    alias source urlAdr
    alias channel sub_topic

    def self.valid? response
      ACTV::VideoValidator.new(response).valid?
    end

    def keywords
      @keywords ||= tag_by_description 'keywords'
    end

    def duration
      @duration ||= tag_by_description 'duration'
    end

    def height
      @height ||= tag_by_description 'height'
    end

    def type
      @type ||= tag_by_description 'type'
    end

    def width
      @width ||= tag_by_description 'width'
    end

    def filesize
      @filesize ||= tag_by_description 'filesize'
    end

    def bitrate
      @bitrate ||= tag_by_description 'bitrate'
    end

    def canonicalUrl
      @canonical_url ||= tag_by_description 'canonicalUrl'
    end

    alias canonical_url canonicalUrl

    def image
      @image ||= image_by_name 'videoImage'
    end

    alias thumbnail image

    def cover
      image.url if image
    end

    def is_video?
      true
    end

  end
end