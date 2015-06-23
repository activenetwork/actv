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

    def asset_categories
      response[:assetCategories] || []
    end

    def taxonomy_has? name
      asset_categories.any? do |cat|
        cat[:category][:categoryTaxonomy].downcase.include? name.downcase
      end
    end

    def category_is? name
      asset_categories.any? do |cat|
        cat[:category][:categoryName].downcase == name.downcase
      end
    end
  end
end
