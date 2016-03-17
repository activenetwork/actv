require 'actv/asset'
require 'nokogiri'
require 'active_support/core_ext/module/delegation'
require 'actv/authorable'

module ACTV
  class Article < Asset
    include Authorable
    delegate :image_url, :footer, :bio, :photo, :name_from_footer, to: :author, prefix: true

    def self.valid? response
      ACTV::ArticleValidator.new(response).valid?
    end

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

    def is_article?
      true
    end

    def reference_articles
      article_references = references.select { |ref| ref.type.downcase == 'reference-article' }
      @reference_articles ||= ACTV.asset(article_references.map(&:id)) if article_references
    end

    private

    def resolve_inline_ad_tag
      tag = tag_by_description 'inlinead'
      return false if tag && tag.downcase != 'true'
      true
    end
  end
end
