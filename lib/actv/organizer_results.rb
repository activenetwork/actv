module ACTV
  class OrganizerResults < ACTV::Base
    attr_reader :items_per_page, :start_index, :total_results

    def results
      @results ||= Array(@attrs[:results]).map do |organizer|
        ACTV::Organizer.new(organizer)
      end
    end
  end
end
