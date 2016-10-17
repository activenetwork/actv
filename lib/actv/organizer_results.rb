module ACTV
  class OrganizerResults < ACTV::Base
    attr_reader :item_per_page, :start_index, :total

    def results
      @results ||= Array(@attrs[:results]).map do |organizer|
        ACTV::Organizer.new(organizer)
      end
    end
    def total
      @total ||= @attrs[:total]
    end

    alias total_results total
    alias items_per_page item_per_page
  end
end
