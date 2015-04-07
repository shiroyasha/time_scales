require 'time'
require 'time_scales/frame/assembly_part'

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

      faps = frame_parts.map{ |key,value| AssemblyPart.new( key, value ) }
      faps.sort_by! { |fap| -fap.scale }

      faps.first.outer_scope!
      faps[0..-2].zip( faps[1..-1] ).each do |a,b|
        b.component_of! a.part
      end

      parts = faps.map { |fap| fap.part }
      klass = frame_types.detect { |type| type.parts == parts }

      values = faps.map { |fap| fap.value }
      klass.new( *values )
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

      def initialize(*args)
        _initialize args
      end

      private

      def _initialize(args_array)
        #stub
      end

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
        @begin_time = begin
          struct = TimeStruct.new
          prepare_time_struct struct
          Time.new( *struct.to_a )
        end
      end

      def succ_begin_time
        raise NotImplementedError, "Subclass responsibility"
      end

      private

      def prepare_time_struct(struct)
        # stub
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

    class YearOfSchemeOnly < Frame::SchemeRelativeFrame
      include HasYearOfScheme

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

    class MonthOfYearOnly < Frame::Base
      include HasMonthOfYear
    end

    module HasMonthOfQuarter
      def self.included(other)
        other.extend HasMonthOfQuarter::ClassMixin
      end

      attr_reader :month_of_quarter

      def month
        month_of_quarter
      end

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

    class MonthOfQuarterOnly < Frame::Base
      include HasMonthOfQuarter
    end

    module HasQuarterOfYear
      def self.included(other)
        other.extend HasQuarterOfYear::ClassMixin
      end

      attr_reader :quarter_of_year

      def quarter
        quarter_of_year
      end

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

    class QuarterOfYearOnly < Frame::Base
      include HasQuarterOfYear
    end

    class QuarterOfYear_Month < Frame::Base
      include HasQuarterOfYear
      include HasMonthOfQuarter
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
    end

    class YearOfScheme_Quarter_Month < SchemeRelativeFrame
      include HasYearOfScheme
      include HasQuarterOfYear
      include HasMonthOfQuarter
      include HasMonthOfSchemePrecision
    end

  end

end
