require 'actv/asset'
require 'active_support/core_ext/object/blank'
module ACTV
  class Author < Asset
    def self.build_from_article article
      new article
    end

    def name
      self.author_name.presence || name_from_footer.presence
    end

    def footer
      @footer ||= description_by_type 'authorFooter'
    end

    def bio
      @bio ||= begin
        bio_node = get_from_footer('div.author-text')
        bio_node.inner_html unless bio_node.nil?
      end
    end

    def photo
      @photo ||= begin
        image_node = get_from_footer 'div.signature-block-photo img'
        image_node = image_node.attribute 'src'
        image = ACTV::AssetImage.new imageUrlAdr: image_node
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
        name_node = get_from_footer('span.author-name')
        name_node.text unless name_node.nil?
      end
    end

    private

    def get_from_footer(selector)
      node = nil

      if !footer.nil? && !footer.empty?
        doc = Nokogiri::HTML(footer)
        node = doc.css(selector).first
      end

      node
    end
  end
end
