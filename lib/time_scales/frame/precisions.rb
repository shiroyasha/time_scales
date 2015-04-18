module TimeScales
  module Frame

    module Precisions

      module HasYearOfSchemePrecision
        def succ_begin_time
          @end_time ||= Time.new( begin_time.year + 1 )
        end
      end

      module Has_N_MonthsOfSchemePrecision
        def succ_begin_time
          @succ_begin_time ||= begin
            succ_y = year_of_scheme
            succ_m = begin_time.month + n_months_precision
            if succ_m > 12
              succ_y += 1 ; succ_m = 1
            end
            Time.new( succ_y, succ_m )
          end
        end

        private

        # Precision unit size in months. A year must be divisible
        # by this value.
        def n_months_precision
          raise NotImplementedError, "Subclass responsibility"
        end
      end

      module HasMonthOfSchemePrecision
        include Has_N_MonthsOfSchemePrecision

        private

        def n_months_precision
          1
        end
      end

      module HasQuarterOfSchemePrecision
        include Has_N_MonthsOfSchemePrecision

        private

        def n_months_precision
          3
        end
      end

      module HasDayOfSchemePrecision
        # Gets us to the early part of the next day, regardless
        # of DST handling, leap seconds, etc.
        SECONDS_IN_26_HOURS = 60 * 60 * 26

        def succ_begin_time
          t = begin_time + SECONDS_IN_26_HOURS
          @succ_begin_time ||= Time.new(t.year, t.month, t.day)
        end
      end

      module HasHourOfSchemePrecision
        SECONDS_PER_HOUR = 60 * 60

        def succ_begin_time
          @succ_begin_time ||= begin_time + SECONDS_PER_HOUR
        end
      end

    end

  end
end
