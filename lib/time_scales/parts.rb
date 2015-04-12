module TimeScales

  module Parts

    def self.all
      @all_parts ||= [
        YearOfScheme,
        QuarterOfYear,
        MonthOfYear,
        MonthOfQuarter,
        DayOfMonth,
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
    end

    class YearOfSchemeClass < AbstractPart
      include Singleton

      def symbol ; :year_of_scheme ; end
      def subdivision ; Units::Year   ; end
      def scope       ; Units::Scheme ; end
      def default_for_unit? ; true    ; end
    end

    YearOfScheme = YearOfSchemeClass.instance


    class QuarterOfYearClass < AbstractPart
      include Singleton

      def symbol ; :quarter_of_year ; end
      def subdivision ; Units::Quarter ; end
      def scope       ; Units::Year    ; end
      def default_for_unit? ; true ; end
    end

    QuarterOfYear = QuarterOfYearClass.instance


    class MonthOfYearClass < AbstractPart
      include Singleton

      def symbol ; :month_of_year ; end
      def subdivision ; Units::Month ; end
      def scope       ; Units::Year  ; end
      def default_for_unit? ; true ; end
    end

    MonthOfYear = MonthOfYearClass.instance


    class MonthOfQuarterClass < AbstractPart
      include Singleton

      def symbol ; :month_of_quarter ; end
      def subdivision ; Units::Month   ; end
      def scope       ; Units::Quarter ; end
      def default_for_unit? ; false    ; end
    end

    MonthOfQuarter = MonthOfQuarterClass.instance


    class DayOfMonthClass < AbstractPart
      include Singleton

      def symbol ; :day_of_month  ; end
      def subdivision ; Units::Day   ; end
      def scope       ; Units::Month ; end
      def default_for_unit? ; true ; end
    end

    DayOfMonth = DayOfMonthClass.instance

  end

end
