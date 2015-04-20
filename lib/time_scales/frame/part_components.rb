module TimeScales
  module Frame

    module PartComponents

      module HasYearOfScheme
        def self.included(other)
          other.extend HasYearOfScheme::ClassMixin
        end

        attr_reader :year_of_scheme

        alias year year_of_scheme

        private

        def _initialize(args_array)
          super
          @year_of_scheme = ensure_fixnum( args_array.shift )
        end

        def prepare_time_struct(struct)
          struct.year = (struct.year || 1) + year_of_scheme - 1
          super
        end

        module ClassMixin
          protected

          def _parts
            super << Parts::YearOfScheme
          end
        end
      end

      module HasMonthOfYear
        def self.included(other)
          other.extend HasMonthOfYear::ClassMixin
        end

        attr_reader :month_of_year

        alias month month_of_year

        private

        def _initialize(args_array)
          super
          @month_of_year = ensure_fixnum( args_array.shift )
        end

        def prepare_time_struct(struct)
          struct.month = (struct.month || 1) + month_of_year - 1
          super
        end

        module ClassMixin
          protected

          def _parts
            super << Parts::MonthOfYear
          end
        end
      end

      module HasDayOfMonth
        def self.included(other)
          other.extend HasDayOfMonth::ClassMixin
        end

        attr_reader :day_of_month

        alias day day_of_month

        private

        def _initialize(args_array)
          super
          @day_of_month = ensure_fixnum( args_array.shift )
        end

        def prepare_time_struct(struct)
          struct.day = (struct.day || 1) + day_of_month - 1
          super
        end

        module ClassMixin
          protected

          def _parts
            super << Parts::DayOfMonth
          end
        end
      end

      module HasDayOfYear
        def self.included(other)
          other.extend HasDayOfYear::ClassMixin
        end

        attr_reader :day_of_year

        alias day day_of_year

        private

        def _initialize(args_array)
          super
          @day_of_year = ensure_fixnum( args_array.shift )
        end

        def prepare_time_struct(struct)
          struct.day = (struct.day || 1) + day_of_year - 1
          super
        end

        module ClassMixin
          protected

          def _parts
            super << Parts::DayOfYear
          end
        end
      end

      module HasHourOfDay
        def self.included(other)
          other.extend HasHourOfDay::ClassMixin
        end

        attr_reader :hour_of_day

        alias hour hour_of_day

        private

        def _initialize(args_array)
          super
          @hour_of_day = ensure_fixnum( args_array.shift )
        end

        def prepare_time_struct(struct)
          struct.hour = struct.hour.to_i + hour_of_day
          super
        end

        module ClassMixin
          protected

          def _parts
            super << Parts::HourOfDay
          end
        end
      end

      module HasMinuteOfHour
        def self.included(other)
          other.extend HasMinuteOfHour::ClassMixin
        end

        attr_reader :minute_of_hour

        alias minute minute_of_hour

        private

        def _initialize(args_array)
          super
          @minute_of_hour = ensure_fixnum( args_array.shift )
        end

        def prepare_time_struct(struct)
          struct.minute = struct.minute.to_i + minute_of_hour
          super
        end

        module ClassMixin
          protected

          def _parts
            super << Parts::MinuteOfHour
          end
        end
      end

      module HasMonthOfQuarter
        def self.included(other)
          other.extend HasMonthOfQuarter::ClassMixin
        end

        attr_reader :month_of_quarter

        alias month month_of_quarter

        private

        def _initialize(args_array)
          super
          @month_of_quarter = ensure_fixnum( args_array.shift )
        end

        def prepare_time_struct(struct)
          struct.month = (struct.month || 1) + month_of_quarter - 1
          super
        end

        module ClassMixin
          protected

          def _parts
            super << Parts::MonthOfQuarter
          end
        end
      end

      module HasQuarterOfYear
        def self.included(other)
          other.extend HasQuarterOfYear::ClassMixin
        end

        attr_reader :quarter_of_year

        alias quarter quarter_of_year

        private

        def _initialize(args_array)
          super
          @quarter_of_year = ensure_fixnum( args_array.shift )
        end

        def prepare_time_struct(struct)
          to_month =
            (struct.month || 1) +
            3 * (quarter_of_year - 1)
          if to_month > 12
            struct.year = (struct.year || 1) + 1
            to_month -= 12
            struct.month = to_month
          else
            struct.month = to_month
          end
          super
        end

        module ClassMixin
          protected

          def _parts
            super << Parts::QuarterOfYear
          end
        end
      end

    end

  end
end
