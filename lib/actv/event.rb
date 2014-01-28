require 'actv/asset'

module ACTV
  class Event < ACTV::Asset
    attr_reader :salesStartDate, :salesEndDate, :activityStartDate, :activityEndDate
    alias sales_start_date salesStartDate
    alias sales_end_date salesEndDate
    alias activity_start_date activityStartDate
    alias activity_end_date activityEndDate

    def online_registration_available?
      if is_present?(self.registrationUrlAdr)
        if is_present?(self.legacy_data) && is_present?(self.legacy_data.onlineRegistration)
          self.legacy_data.onlineRegistration.downcase == 'true'
        else
          true
        end
      else
        false
      end
    end

    def registration_open?
      if online_registration_available?
        is_now_between? authoritative_reg_start_date, authoritative_reg_end_date
      else
        false
      end
    end

    def registration_closed?
      if online_registration_available?
        is_now_after? authoritative_reg_end_date
      else
        false
      end
    end

    def registration_not_yet_open?
      if online_registration_available?
        is_now_before? authoritative_reg_start_date
      else
        false
      end
    end

    def event_ended?
      if is_present? activity_end_date
        is_now_after? "#{activity_end_date.split('T').first}T23:59:59"
      end
    end

    def registration_opening_soon?(time_in_days=3)
      @reg_open_soon ||= begin
        if online_registration_available?
          if self.sales_start_date
            if now_in_utc >= utc_time(self.sales_start_date) - time_in_days.days and
              now_in_utc < utc_time(self.sales_start_date)
              return true
            end
          end
        end

        false
      end
    end

    def registration_closing_soon?(time_in_days=3)
      @reg_closing_soon ||= begin
        if online_registration_available?
          if self.sales_end_date
            if now_in_utc >= utc_time(self.sales_end_date) - time_in_days.days and
              now_in_utc < utc_time(self.end_date)
              return true
            end
          end
        end

        false
      end
    end

    def display_close_date
      @display_close_date ||= begin
        val = tag_by_description 'displayclosedate'
        if val
          val.downcase == 'true'
        else
          true
        end
      end
    end
    alias display_close_date? display_close_date

    ############

    # Returns the asset's registration open date
    # in UTC.  This is pulled from the salesStartDate
    def registration_open_date
      Time.parse "#{authoritative_reg_start_date} UTC"
    end

    # Returns the asset's registration end date
    # in UTC.  This is pulled from the salesEndDate
    def registration_close_date
      Time.parse "#{authoritative_reg_end_date} UTC"
    end

    # Returns the asset's start date
    # in UTC.  This is pulled from the activityStartDate.
    def event_start_date
      Time.parse "#{activity_start_date} #{format_timezone_offset(timezone_offset)}"
    end

    # Returns the asset's end date
    # in UTC.  This is pulled from the activityEndDate.
    def event_end_date
      Time.parse "#{activity_end_date} #{format_timezone_offset(timezone_offset)}"
    end

    def timezone_offset
      place.timezoneOffset + place.timezoneDST
    end

    ############

    def image_url
      defaultImage = 'http://www.active.com/images/events/hotrace.gif'
      image = ''

      self.assetImages.each do |i|
        if i.imageUrlAdr.downcase != defaultImage
          image = i.imageUrlAdr
          break
        end
      end

      if image.blank?
        if (self.logoUrlAdr && self.logoUrlAdr != defaultImage && self.logoUrlAdr =~ URI::regexp)
          image = self.logoUrlAdr
        end
      end
      image
    end

    alias online_registration? online_registration_available?
    alias reg_open? registration_open?
    alias reg_closed? registration_closed?
    alias registration_not_open? registration_not_yet_open?
    alias reg_not_open? registration_not_yet_open?
    alias reg_not_yet_open? registration_not_yet_open?
    alias ended? event_ended?

    private

    # EG: -7 => "-0700"
    def format_timezone_offset(offset)
      (offset < 0 ? "-" : "") << offset.abs.to_s.rjust(2,'0') << '00'
    end

    def authoritative_reg_end_date
      if is_present? sales_end_date
        sales_end_date
      elsif is_present? activity_end_date
        "#{activity_end_date.split('T').first}T23:59:59"
      elsif is_present? activity_start_date
        activity_start_date
      else
        "2100-12-31T23:59:59"
      end
    end

    def authoritative_reg_start_date
      if is_present? sales_start_date
        sales_start_date
      else
        "1970-01-01T00:00:00"
      end
    end

    def is_now_before? date_string
      now_in_utc < utc_time(date_string)
    end

    def is_now_after? date_string
      !is_now_before? date_string
    end

    def is_now_between? start_date_string, end_date_string
      utc_time(start_date_string) < now_in_utc && now_in_utc < utc_time(end_date_string)
    end

    def is_present? obj
      !is_empty? obj
    end

    def is_empty? obj
      obj.respond_to?(:empty?) ? obj.empty? : !obj
    end

    def now_in_utc
      Time.now.utc
    end

    def utc_time(time_string)
      return nil if time_string.nil? or time_string.empty?
      return Time.parse(time_string).utc
    end

  end
end


