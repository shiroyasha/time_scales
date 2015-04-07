module TimeScales
  module Frame

    module Precisions

      module HasYearOfSchemePrecision
        def succ_begin_time
          @end_time ||= Time.new( begin_time.year + 1 )
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

    end

  end
end
