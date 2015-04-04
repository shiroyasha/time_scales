require 'time'

module TimeScales

  module Frame
    def self.[](parts = {})
      if parts.key?(:year)
        if parts.key?(:month)
          Frame::YearOfScheme_Month.new( *parts.values_at(:year, :month) )
        else
          Frame::YearOfSchemeOnly.new( parts[:year] )
        end
      elsif parts.key?(:month)
        Frame::MonthOfYearOnly.new( parts[:month] )
      else
        Frame::NullFrame.new
      end
    end

    class Base

      private

      def ensure_fixnum(value)
        return value if Fixnum === value
        raise ArgumentError, "Time part value must be of Fixnum type (a numeric integer)"
      end
    end

    class SchemeRelativeFrame < Frame::Base
      def to_time
        begin_time
      end

      def to_range
        @to_range ||= ( begin_time...succ_begin_time )
      end

      def begin_time
        raise NotImplementedError, "Subclass responsibility"
      end

      def succ_begin_time
        raise NotImplementedError, "Subclass responsibility"
      end
    end

    class NullFrame < Frame::Base
    end

    class YearOfSchemeOnly < Frame::SchemeRelativeFrame
      def initialize(year)
        @year_of_scheme = ensure_fixnum( year )
      end

      attr_reader :year_of_scheme

      def year
        year_of_scheme
      end

      def begin_time
        @begin_time ||= Time.new( year_of_scheme )
      end

      def succ_begin_time
        @end_time ||= Time.new( year_of_scheme + 1 )
      end
    end

    class MonthOfYearOnly < Frame::Base
      def initialize(month)
        @month_of_year = ensure_fixnum( month )
      end

      attr_reader :month_of_year

      def month
        month_of_year
      end
    end

    class YearOfScheme_Month < SchemeRelativeFrame
      def initialize(year, month)
        @year_of_scheme = ensure_fixnum( year )
        @month_of_year = ensure_fixnum( month )
      end

      attr_reader :year_of_scheme, :month_of_year

      def year
        year_of_scheme
      end

      def month
        month_of_year
      end

      def begin_time
        @begin_time ||= Time.new( year_of_scheme, month_of_year )
      end

      def succ_begin_time
        @end_time ||= begin
          succ_y = year_of_scheme
          succ_m = month_of_year + 1
          if succ_m > 12
            succ_y += 1 ; succ_m = 1
          end
          Time.new( succ_y, succ_m )
        end
      end
    end

  end

end
