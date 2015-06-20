module ACTV
  class AssetValidator
    attr_reader :response

    def initialize response
      @response = response
    end

    def valid?
      true
    end

    private

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
  end
end
