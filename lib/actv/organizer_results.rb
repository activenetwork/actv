module ACTV
  class OrganizerResults < ACTV::Base
    def results
      @results ||= Array(@attrs[:results]).map do |organizer|
        ACTV::Organizer.new(organizer[:organization])
      end
    end
    def total
      @total ||= @attrs[:total]
    end
  end
end
