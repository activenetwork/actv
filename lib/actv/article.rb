require 'actv/asset'
require 'nokogiri'
require 'active_support/core_ext/module/delegation'

module ACTV
  class Article < ACTV::Asset
    attr_reader :author
    delegate :image_url, :footer, :bio, :photo, :name_from_footer, to: :author, prefix: true

    def source
      @source ||= description_by_type 'articleSource'
    end

    def type
      @type ||= tag_by_description 'articleType'
    end

    def media_gallery?
      type && type.downcase == "mediagallery"
    end

    def image
      @image ||= image_by_name 'image2'
    end

    def subtitle
      @subtitle ||= description_by_type 'subtitle'
    end

    def footer
      @footer ||= description_by_type 'footer'
    end

    def inline_ad
      @inline_ad ||= resolve_inline_ad_tag
    end
    alias inline_ad? inline_ad

    def author
      @author ||= author_from_reference || author_from_article
    end

    def by_line
      @by_line ||= description_by_type 'articleByLine'
    end

    def is_article?
      true
    end

    def author_name_from_by_line
      author_name_regex = /by (.*)/i.match by_line
      author_name_regex[1].strip if author_name_regex.present?
    end

    private


    def author_from_article
      ACTV::Author.build_from_article self.to_hash
    end

    def author_from_reference
      if author_reference
        ACTV.asset(author_reference.id).first
      end
    rescue ACTV::Error::NotFound
      nil
    end

    def author_reference
      references.find { |reference| reference.type == "author" }
    end

    def resolve_inline_ad_tag
      tag = tag_by_description('inlinead')
      return false if tag && tag.downcase != 'true'
      true
    end
  end
end
