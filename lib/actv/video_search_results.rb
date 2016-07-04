require 'actv/search_results'

module ACTV
  class VideoSearchResults < ACTV::SearchResults
    def results
      @results ||= Array(@attrs[:results]).map do |event|
        ACTV::Video.new(event)
      end
    end
  end
end
