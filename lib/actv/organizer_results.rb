module ACTV
  class OrganizerResults < ACTV::Base
    def results
      @results ||= Array(@attrs[:results]).map do |organizer|
        ACTV::Organizer.new(organizer)
      end
    end
    def total
      @total ||= @attrs[:total]
    end
  end
end
