require 'time'

module TimeScales

  module Frame
    def self.[](parts = {})
      if parts.key?(:year)
        if parts.key?(:quarter)
          if parts.key?(:month) || parts.key?(:month_of_quarter)
            part_args = [
              parts[:year],
              parts[:quarter],
              parts[:month] || parts[:month_of_quarter]
            ]
            Frame::YearOfScheme_Quarter_Month.new( *part_args )
          else
            Frame::YearOfScheme_Quarter.new( *parts.values_at(:year, :quarter) )
          end
        elsif parts.key?(:month)
          Frame::YearOfScheme_Month.new( *parts.values_at(:year, :month) )
        else
          Frame::YearOfSchemeOnly.new( parts[:year] )
        end
      elsif parts.key?(:quarter)
        if parts.key?(:month) || parts.key?(:month_of_quarter)
          part_args = [
            parts[:quarter],
            parts[:month] || parts[:month_of_quarter]
          ]
          Frame::QuarterOfYear_Month.new( *part_args )
        else
          Frame::QuarterOfYearOnly.new( parts[:quarter] )
        end
      elsif parts.key?(:month)
        Frame::MonthOfYearOnly.new( parts[:month] )
      elsif parts.key?(:month_of_quarter)
        Frame::MonthOfQuarterOnly.new( parts[:month_of_quarter] )
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

    module HasYearOfScheme
      attr_reader :year_of_scheme

      def year
        year_of_scheme
      end
    end

    class YearOfSchemeOnly < Frame::SchemeRelativeFrame
      include HasYearOfScheme

      def initialize(year)
        @year_of_scheme = ensure_fixnum( year )
      end

      def begin_time
        @begin_time ||= Time.new( year_of_scheme )
      end

      def succ_begin_time
        @end_time ||= Time.new( begin_time.year + 1 )
      end
    end

    module HasMonthOfYear
      attr_reader :month_of_year

      def month
        month_of_year
      end
    end

    class MonthOfYearOnly < Frame::Base
      include HasMonthOfYear

      def initialize(month)
        @month_of_year = ensure_fixnum( month )
      end
    end

    module HasMonthOfQuarter
      attr_reader :month_of_quarter

      def month
        month_of_quarter
      end
    end

    class MonthOfQuarterOnly < Frame::Base
      include HasMonthOfQuarter

      def initialize(month)
        @month_of_quarter = ensure_fixnum( month )
      end
    end

    module HasQuarterOfYear
      attr_reader :quarter_of_year

      def quarter
        quarter_of_year
      end
    end

    class QuarterOfYearOnly < Frame::Base
      include HasQuarterOfYear

      def initialize(quarter)
        @quarter_of_year = ensure_fixnum( quarter )
      end
    end

    class QuarterOfYear_Month < Frame::Base
      include HasQuarterOfYear
      include HasMonthOfQuarter

      def initialize(quarter, month)
        @quarter_of_year = ensure_fixnum( quarter )
        @month_of_quarter = ensure_fixnum( month )
      end
    end

    module HasMonthOfSchemePrecision

      def succ_begin_time
        @end_time ||= begin
          succ_y = year_of_scheme
          succ_m = begin_time.month + 1
          if succ_m > 12
            succ_y += 1 ; succ_m = 1
          end
          Time.new( succ_y, succ_m )
        end
      end

    end

    class YearOfScheme_Month < SchemeRelativeFrame
      include HasYearOfScheme
      include HasMonthOfYear
      include HasMonthOfSchemePrecision

      def initialize(year, month)
        @year_of_scheme = ensure_fixnum( year )
        @month_of_year = ensure_fixnum( month )
      end

      def begin_time
        @begin_time ||= Time.new( year_of_scheme, month_of_year )
      end
    end

    module HasQuarterOfSchemePrecision

      def succ_begin_time
        @end_time ||= begin
          succ_y = year_of_scheme
          succ_m = begin_time.month + 3
          if succ_m > 12
            succ_y += 1 ; succ_m = 1
          end
          Time.new( succ_y, succ_m )
        end
      end

    end

    class YearOfScheme_Quarter < SchemeRelativeFrame
      include HasYearOfScheme
      include HasQuarterOfYear
      include HasQuarterOfSchemePrecision

      def initialize(year, quarter)
        @year_of_scheme = ensure_fixnum( year )
        @quarter_of_year = ensure_fixnum( quarter )
      end

      def begin_time
        @begin_time ||= begin
          m = (quarter_of_year - 1) * 3 + 1
          Time.new( year_of_scheme, m )
        end
      end
    end

    class YearOfScheme_Quarter_Month < SchemeRelativeFrame
      include HasYearOfScheme
      include HasQuarterOfYear
      include HasMonthOfQuarter
      include HasMonthOfSchemePrecision

      def initialize(year, quarter, month)
        @year_of_scheme = ensure_fixnum( year )
        @quarter_of_year = ensure_fixnum( quarter )
        @month_of_quarter = ensure_fixnum( month )
      end

      def begin_time
        @begin_time ||= begin
          m = (quarter_of_year - 1) * 3 + month_of_quarter
          Time.new( year_of_scheme, m )
        end
      end
    end

  end

end
