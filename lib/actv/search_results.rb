require 'actv/base'
require 'actv/facet'
require 'actv/facet_value'
require 'actv/suggestion'

module ACTV
  class SearchResults < ACTV::Base
    attr_reader :items_per_page, :start_index, :total_results, :original_query, :actual_query

    # @return [Array<ACTV::Asset>]
    def results
      @results ||= Array(@attrs[:results]).map do |asset|
        ACTV::Asset.new(asset)
      end
    end

    # @return [Array<ACTV::Facet>]
    def facets
      @facets ||= Array(@attrs[:facets]).map do |facet|
        ACTV::Facet.new(facet)
      end
    end

    # @return [Array<ACTV::FacetValue>]
    def facet_values
      @facet_values ||= Array(@attrs[:facet_values]).map do |facet_value|
        ACTV::FacetValue.new(facet_value)
      end
    end

    def suggestions
      @suggestions ||= Array(@attrs[:suggestions]).map do |suggestion|
        ACTV::Suggestion.new(suggestion)
      end
    end
  end
end