require 'actv/asset'
require 'active_support/core_ext/object/blank'

module ACTV
  class Author < Asset
    def self.build_from_article article_hash
      new article_hash
    end

    def self.valid? response
      ACTV::AuthorValidator.new(response).valid?
    end

    def name
      name_from_footer.presence || self.author_name.presence
    end

    def footer
      @footer ||= description_by_type 'authorFooter'
    end

    def bio
      @bio ||= begin
        bio_node = from_footer 'div.author-text'
        bio_node.inner_html unless bio_node.nil?
      end
    end

    def photo
      @photo ||= begin
        image_node = from_footer 'div.signature-block-photo img'
        if image_node
          url = image_node.attribute('src').to_s
          ACTV::AssetImage.new imageUrlAdr: url
        end
      end
    end

    def image_url
      if photo.url && photo.url.start_with?("/")
        "http://www.active.com#{photo.url}"
      else
        photo.url
      end
    end

    def name_from_footer
      @name_from_footer ||= begin
        name_node = from_footer 'span.author-name'
        name_node.text unless name_node.nil?
      end
    end

    private

    def from_footer selector
      if footer.present?
        doc = Nokogiri::HTML footer
        doc.css(selector).first
      end
    end
  end
end
