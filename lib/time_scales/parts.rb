require 'singleton'

module TimeScales

  module Parts

    def self.all
      @all_parts ||= [
        YearOfScheme,
        QuarterOfYear,
        MonthOfYear,
        MonthOfQuarter,
      ].freeze
    end

    class AbstractPart
      def ===(other)
        self == other || symbol == other || subdivision_symbol == other
      end

      def symbol
        raise NotImplementedError, "Subclass responsibility"
      end

      def subdivision_symbol
        raise NotImplementedError, "Subclass responsibility"
      end

      def scope_symbol
        raise NotImplementedError, "Subclass responsibility"
      end

      # Rough order of magnitude of subdivision unit size.
      # 4.67 times the base-10 logarithm of approximate number of
      # seconds per unit, then round to nearest integer.
      def scale
        raise NotImplementedError, "Subclass responsibility"
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
      def subdivision_symbol ; :year   ; end
      def scope_symbol       ; :scheme ; end
      def scale              ;  35     ; end
      def default_for_unit?  ; true    ; end
    end

    YearOfScheme = YearOfSchemeClass.instance


    class QuarterOfYearClass < AbstractPart
      include Singleton

      def symbol ; :quarter_of_year ; end
      def subdivision_symbol ; :quarter ; end
      def scope_symbol       ; :year    ; end
      def scale              ;  32     ; end
      def default_for_unit?  ; true    ; end
    end

    QuarterOfYear = QuarterOfYearClass.instance


    class MonthOfYearClass < AbstractPart
      include Singleton

      def symbol ; :month_of_year ; end
      def subdivision_symbol ; :month ; end
      def scope_symbol       ; :year  ; end
      def scale              ;  30    ; end
      def default_for_unit?  ; true    ; end
    end

    MonthOfYear = MonthOfYearClass.instance


    class MonthOfQuarterClass < AbstractPart
      include Singleton

      def symbol ; :month_of_quarter ; end
      def subdivision_symbol ; :month   ; end
      def scope_symbol       ; :quarter ; end
      def scale              ;  30      ; end
      def default_for_unit?  ; false    ; end
    end

    MonthOfQuarter = MonthOfQuarterClass.instance

  end

end
