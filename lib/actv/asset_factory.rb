module ACTV
  class AssetFactory
    attr_reader :response

    def initialize response_body
      @response = response_body
    end

    def asset
      return ACTV::Author.new response if is_author?
      return ACTV::Event.new response if is_event?
      return ACTV::Article.new response if is_article?
      ACTV::Asset.new response
    end

    private

    def is_event?
      category_is?('event') || taxonomy_has?('event')
    end

    def is_article?
      category_is?('articles') || acm?
    end

    def is_author?
      category_is? 'author'
    end

    def taxonomy_has? name
      response[:assetCategories].any? do |cat|
        cat[:category][:categoryTaxonomy].downcase.include? name.downcase
      end if response[:assetCategories]
    end

    def category_is? name
      response[:assetCategories].any? do |cat|
        cat[:category][:categoryName].downcase == name.downcase
      end if response[:assetCategories]
    end

    def acm?
      response[:sourceSystem][:legacyGuid].upcase == "CA4EA0B1-7377-470D-B20D-BF6BEA23F040" rescue false
    end
  end
end
