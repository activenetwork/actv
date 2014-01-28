require 'actv/search_results'

module ACTV
  class ArticleSearchResults < ACTV::SearchResults
    def results
      @results ||= Array(@attrs[:results]).map do |event|
        ACTV::Article.new(event)
      end
    end

    def first_article? art
      results.first == art
    end
  end
end
