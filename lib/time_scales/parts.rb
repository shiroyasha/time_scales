module TimeScales

  module Parts

    def self.all
      @all_parts ||= [
        YearOfScheme,
        QuarterOfYear,
        MonthOfYear,
        MonthOfQuarter,
        DayOfMonth,
        DayOfYear,
        DayOfQuarter,
        HourOfDay,
      ].freeze
    end

    class AbstractPart
      def ===(other)
        self == other || symbol == other
      end

      def symbol
        raise NotImplementedError, "Subclass responsibility"
      end

      def subdivision
        raise NotImplementedError, "Subclass responsibility"
      end

      def scope
        raise NotImplementedError, "Subclass responsibility"
      end

      def scale
        subdivision.scale
      end

      def default_for_unit?
        raise NotImplementedError, "Subclass responsibility"
      end

      def to_s
        @to_s ||= self.class.name.sub(/Class$/, '').freeze
      end

      def component_mixin
        raise NotImplementedError, "Subclass responsibility"
      end

      def scheme_scoped_precision_mixin
        raise NotImplementedError, "Subclass responsibility"
      end

      def name
        @name ||= /::([^:]+)Class$/.match( self.class.name )[1]
      end

      def subdivision_name
        subdivision.name
      end

      def &(time)
        raise NotImplementedError, "Subclass responsibility"
      end
    end

    class YearOfSchemeClass < AbstractPart
      include Singleton

      def symbol ; :year_of_scheme ; end
      def subdivision ; Units::Year   ; end
      def scope       ; Units::Scheme ; end
      def default_for_unit? ; true    ; end
      def component_mixin ; Frame::PartComponents::HasYearOfScheme ; end
      def scheme_scoped_precision_mixin ; Frame::Precisions::HasYearOfSchemePrecision ; end

      def &(time)
        time.year
      end
    end

    YearOfScheme = YearOfSchemeClass.instance


    class QuarterOfYearClass < AbstractPart
      include Singleton

      def symbol ; :quarter_of_year ; end
      def subdivision ; Units::Quarter ; end
      def scope       ; Units::Year    ; end
      def default_for_unit? ; true ; end
      def component_mixin ; Frame::PartComponents::HasQuarterOfYear ; end
      def scheme_scoped_precision_mixin ; Frame::Precisions::HasQuarterOfSchemePrecision ; end

      def &(time)
        month_offs = time.month - 1
        ( month_offs / 3 ) + 1
      end
    end

    QuarterOfYear = QuarterOfYearClass.instance


    class MonthOfYearClass < AbstractPart
      include Singleton

      def symbol ; :month_of_year ; end
      def subdivision ; Units::Month ; end
      def scope       ; Units::Year  ; end
      def default_for_unit? ; true ; end
      def component_mixin ; Frame::PartComponents::HasMonthOfYear ; end
      def scheme_scoped_precision_mixin ; Frame::Precisions::HasMonthOfSchemePrecision ; end

      def &(time)
        time.month
      end
    end

    MonthOfYear = MonthOfYearClass.instance


    class MonthOfQuarterClass < AbstractPart
      include Singleton

      def symbol ; :month_of_quarter ; end
      def subdivision ; Units::Month   ; end
      def scope       ; Units::Quarter ; end
      def default_for_unit? ; false    ; end
      def component_mixin ; Frame::PartComponents::HasMonthOfQuarter ; end
      def scheme_scoped_precision_mixin ; Frame::Precisions::HasMonthOfSchemePrecision ; end

      def &(time)
        month_offs = time.month - 1
        ( month_offs % 3 ) + 1
      end
    end

    MonthOfQuarter = MonthOfQuarterClass.instance


    class DayOfMonthClass < AbstractPart
      include Singleton

      def symbol ; :day_of_month ; end
      def subdivision ; Units::Day   ; end
      def scope       ; Units::Month ; end
      def default_for_unit? ; true ; end
      def component_mixin ; Frame::PartComponents::HasDayOfMonth ; end
      def scheme_scoped_precision_mixin ; Frame::Precisions::HasDayOfSchemePrecision ; end

      def &(time)
        time.day
      end
    end

    DayOfMonth = DayOfMonthClass.instance


    class DayOfYearClass < AbstractPart
      include Singleton

      def symbol ; :day_of_year ; end
      def subdivision ; Units::Day   ; end
      def scope       ; Units::Year ; end
      def default_for_unit? ; false ; end
      def component_mixin ; Frame::PartComponents::HasDayOfYear ; end
      def scheme_scoped_precision_mixin ; Frame::Precisions::HasDayOfSchemePrecision ; end

      def &(time)
        time.yday
      end
    end

    DayOfYear = DayOfYearClass.instance


    class DayOfQuarterClass < AbstractPart
      include Singleton

      def symbol ; :day_of_quarter ; end
      def subdivision ; Units::Day     ; end
      def scope       ; Units::Quarter ; end
      def default_for_unit? ; false ; end
      def component_mixin ; Frame::PartComponents::HasDayOfQuarter ; end
      def scheme_scoped_precision_mixin ; Frame::Precisions::HasDayOfSchemePrecision ; end

      def &(time)
        month_offs = time.month - 1
        qtr_offs = month_offs / 3
        qtr_start_mo = ( qtr_offs * 3 ) + 1
        qtr_start_time = Time.new( time.year, qtr_start_mo, 1)
        time.yday - qtr_start_time.yday + 1
      end
    end

    DayOfQuarter = DayOfQuarterClass.instance


    class HourOfDayClass < AbstractPart
      include Singleton

      def symbol ; :hour_of_day ; end
      def subdivision ; Units::Hour     ; end
      def scope       ; Units::Day ; end
      def default_for_unit? ; false ; end
      def component_mixin ; Frame::PartComponents::HasHourOfDay ; end
      def scheme_scoped_precision_mixin ; Frame::Precisions::HasHourOfSchemePrecision ; end

      def &(time)
        time.hour
      end
    end

    HourOfDay = HourOfDayClass.instance

  end

end
