require 'time'
require 'time_scales/frame/assembly_part'
require 'time_scales/frame/base'
require 'time_scales/frame/scheme_relative_frame'
require 'time_scales/frame/part_components'

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

    class NullFrame < Frame::Base
      include Singleton
    end

    class YearOfSchemeOnly < Frame::SchemeRelativeFrame
      include PartComponents::HasYearOfScheme

      def succ_begin_time
        @end_time ||= Time.new( begin_time.year + 1 )
      end
    end

    class MonthOfYearOnly < Frame::Base
      include PartComponents::HasMonthOfYear
    end

    class MonthOfQuarterOnly < Frame::Base
      include PartComponents::HasMonthOfQuarter
    end

    class QuarterOfYearOnly < Frame::Base
      include PartComponents::HasQuarterOfYear
    end

    class QuarterOfYear_Month < Frame::Base
      include PartComponents::HasQuarterOfYear
      include PartComponents::HasMonthOfQuarter
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
      include PartComponents::HasYearOfScheme
      include PartComponents::HasMonthOfYear
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
      include PartComponents::HasYearOfScheme
      include PartComponents::HasQuarterOfYear
      include HasQuarterOfSchemePrecision
    end

    class YearOfScheme_Quarter_Month < SchemeRelativeFrame
      include PartComponents::HasYearOfScheme
      include PartComponents::HasQuarterOfYear
      include PartComponents::HasMonthOfQuarter
      include HasMonthOfSchemePrecision
    end

  end

end
