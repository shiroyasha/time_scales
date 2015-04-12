module TimeScales

  module Units

    class AbstractUnit
      def ===(other)
        self == other || symbol == other
      end

      def symbol
        raise NotImplementedError, "Subclass responsibility"
      end

      # Rough order of magnitude of subdivision unit size.
      # 1.407 times the base-2 logarithm of approximate number of
      # seconds per unit, then round to nearest integer.
      def scale
        raise NotImplementedError, "Subclass responsibility"
      end

      def name
        @name ||= /::([^:]+)Class$/.match( self.class.name )[1]
      end
    end

    class SchemeClass < AbstractUnit
      include Singleton

      def symbol ; :scheme ; end
      def scale  ;  9999   ; end
    end

    Scheme = SchemeClass.instance


    class YearClass < AbstractUnit
      include Singleton

      def symbol ; :year ; end
      def scale  ;  35   ; end
    end

    Year = YearClass.instance


    class QuarterClass < AbstractUnit
      include Singleton

      def symbol ; :quarter ; end
      def scale  ;  32      ; end
    end

    Quarter = QuarterClass.instance


    class MonthClass < AbstractUnit
      include Singleton

      def symbol ; :month ; end
      def scale  ;  30    ; end
    end

    Month = MonthClass.instance


    class DayClass < AbstractUnit
      include Singleton

      def symbol ; :day ; end
      def scale  ;  23  ; end
    end

    Day = DayClass.instance

  end

end
