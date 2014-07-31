require 'actv/identity'

module ACTV
  class Recurrence < Base

    attr_reader :activityStartDate, :startTime, :activityEndDate, :endTime, :frequencyInterval, :frequency,
                :days, :monthWeekInterval, :activityExclusions

    alias start_date activityStartDate
    alias startTime startTime
    alias end_date activityEndDate
    alias end_time endTime
    alias frequency_interval frequencyInterval
    alias month_week_interval monthWeekInterval
    alias exclusions activityExclusions
  end
end
