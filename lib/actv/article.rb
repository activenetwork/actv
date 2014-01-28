require 'actv/asset'
require 'nokogiri'

module ACTV
  class Article < ACTV::Asset

    def author_footer
      @author_footer ||= description_by_type 'authorFooter'
    end

    def by_line
      @author ||= description_by_type 'articleByLine'
    end

    def author_bio
      @author_bio ||= begin
        bio_node = get_from_author_footer('div.author-text')
        bio_node.inner_html unless bio_node.nil?
      end
    end

    def author_photo
      @author_photo ||= begin
        image = nil

        image_node = get_from_author_footer('div.signature-block-photo img')
        if !image_node.nil?
          image = ACTV::AssetImage.new({imageUrlAdr: image_node.attribute('src').text}) if image_node.attribute 'src'
        end

        image
      end
    end

    def author_name_from_footer
      @author_name_from_footer ||= begin
        name_node = get_from_author_footer('span.author-name')
        name_node.text unless name_node.nil?
      end
    end

    def source
      @source ||= description_by_type 'articleSource'
    end

    def type
      @type ||= tag_by_description 'articleType'
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
      @inline_ad ||= begin
        val = tag_by_description 'inlinead'
        if val
          val.downcase == 'true'
        else
          true
        end
      end
    end
    alias inline_ad? inline_ad

    private

      def get_from_author_footer(selector)
        node = nil

        if !author_footer.nil? && !author_footer.empty?
          doc = Nokogiri::HTML(author_footer)
          node = doc.css(selector).first
        end

        node
      end
  end
end


