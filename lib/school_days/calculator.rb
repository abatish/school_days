
module SchoolDays
  class Calculator
    def initialize(days)
      @days = days
    end

    def after(time = Time.now)
      # example: 2.school_days.after(tuesday)
      date = time
      date = time.to_date if time.is_a?(Time)

      @days.times do
        begin
          date = date + 1
        end until date.school_day?
        # TODO: in here, check school_session_for_date for every new date
        # if it returns something different than our own (or nil) then we
        # need to do something clever. RPW 01-25-2011

        # TODO: also check that the date is in the range of the school year at all
        # (a date could be outside all sessions - during a semester break, for example,
        # but still be inside the school year.)
      end
      date
    end
    alias_method :from_now, :after

    def before(time = Time.now)
      
    end
    alias_method :until, :before

    # a new method, more of a helper for this API then an actual public method...
    # however, this will return the session a date is associated with, or nil
    # if this falls totally outside the known school year
    def school_session_for_date(date)
      SchoolDays.config.school_sessions.detect do |school_session|
        school_session[:start_date] < date && date < school_session[:end_date]
      end
    end

    # another semi-private method. TODO: it seems useful to expose this, but how?
    def is_in_school_year?(date)
      SchoolDays.config.school_year_start < date && date < SchoolDays.config.school_year_end
    end
  end
end