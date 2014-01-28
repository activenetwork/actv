require 'actv/search_results'

module ACTV
  class EventSearchResults < ACTV::SearchResults
    def results
      @results ||= Array(@attrs[:results]).map do |article|
        ACTV::Event.new(article)
      end
    end
  end
end