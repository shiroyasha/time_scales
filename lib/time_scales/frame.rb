require 'time'
require 'singleton'

module TimeScales

  module Frame
    def self.frame_types
      @frame_types ||=
        constants.
        map { |c_name| const_get(c_name) }.
        select { |c_value| Class === c_value }.
        select { |c_class| c_class.ancestors.include?( Frame::Base ) }.
        reject { |frame_class| frame_class == Frame::Base }
    end

    def self.[](frame_parts = {})
      return Frame::NullFrame.instance if frame_parts.keys.empty?

      frame_part_types = frame_parts.keys.map { |key|
        [
          key,
          Parts.all.select { |type| type === key }
        ]
      }
      frame_part_types.sort_by! { |(key,types)| -types.first.scale }

      frame_part_types.first[1].select! { |type|
        type.symbol == frame_part_types.first[0] ||
          type.default_for_unit?
      }

      frame_part_types[0..-2].zip( frame_part_types[1..-1] ).each do |(_,a),(_,b)|
        scope_symbol = a.first.subdivision_symbol
        b.select! { |type| type.scope_symbol == scope_symbol }
      end

      types = frame_part_types.map { |i| i[1][0] }

      klass = frame_types.detect{ |f_type| f_type.parts == types }

      key_seq = frame_part_types.map { |key,_| key }

      klass.new( *frame_parts.values_at( *key_seq ) )
    end

    class Base

      class << self
        def parts
          @parts ||=
            _parts.
            sort_by { |part| -part.scale }.
            freeze
        end

        private

        def _parts
          []
        end
      end

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
      include Singleton
    end

    module HasYearOfScheme
      def self.included(other)
        other.extend HasYearOfScheme::ClassMixin
      end

      attr_reader :year_of_scheme

      def year
        year_of_scheme
      end

      module ClassMixin
        protected

        def _parts
          super << Parts::YearOfScheme
        end
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
      def self.included(other)
        other.extend HasMonthOfYear::ClassMixin
      end

      attr_reader :month_of_year

      def month
        month_of_year
      end

      module ClassMixin
        protected

        def _parts
          super << Parts::MonthOfYear
        end
      end
    end

    class MonthOfYearOnly < Frame::Base
      include HasMonthOfYear

      def initialize(month)
        @month_of_year = ensure_fixnum( month )
      end
    end

    module HasMonthOfQuarter
      def self.included(other)
        other.extend HasMonthOfQuarter::ClassMixin
      end

      attr_reader :month_of_quarter

      def month
        month_of_quarter
      end

      module ClassMixin
        protected

        def _parts
          super << Parts::MonthOfQuarter
        end
      end
    end

    class MonthOfQuarterOnly < Frame::Base
      include HasMonthOfQuarter

      def initialize(month)
        @month_of_quarter = ensure_fixnum( month )
      end
    end

    module HasQuarterOfYear
      def self.included(other)
        other.extend HasQuarterOfYear::ClassMixin
      end

      attr_reader :quarter_of_year

      def quarter
        quarter_of_year
      end

      module ClassMixin
        protected

        def _parts
          super << Parts::QuarterOfYear
        end
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
