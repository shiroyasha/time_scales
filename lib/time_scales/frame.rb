require 'time'
require 'time_scales/frame/assembly_part'
require 'time_scales/frame/base'
require 'time_scales/frame/scheme_relative_frame'
require 'time_scales/frame/part_components'
require 'time_scales/frame/precisions'

module TimeScales

  module Frame

    class << self
      def type_for(*part_keys)
        return Frame::NullFrame if part_keys.empty?

        faps = part_keys.map { |key| AssemblyPart.new(key) }
        sequence_assembly_parts faps
        class_for_assembly_seq( faps )
      end

      def [](frame_parts = {})
        return Frame::NullFrame.instance if frame_parts.keys.empty?

        faps = frame_parts.map { |key,value| AssemblyPart.new(key, value) }
        sequence_assembly_parts faps
        klass = class_for_assembly_seq( faps )

        values = faps.map { |fap| fap.value }
        klass.new( *values )
      end

      private

      def frame_types
        @frame_types ||=
          constants.
          map { |c_name| const_get(c_name) }.
          select { |c_value| Class === c_value }.
          select { |c_class| c_class.ancestors.include?( Frame::Base ) }.
          reject { |frame_class| frame_class == Frame::Base }
      end

      def sequence_assembly_parts(faps)
        faps.sort_by! { |fap| -fap.scale }

        faps.first.outer_scope!
        faps[0..-2].zip( faps[1..-1] ).each do |a,b|
          b.component_of! a.part
        end
      end

      def class_for_assembly_seq(faps)
        parts = faps.map { |fap| fap.part }
        frame_types.detect { |type| type.parts == parts }
      end
    end


    class NullFrame < Frame::Base
      include Singleton
    end


    class YearOfSchemeOnly < Frame::SchemeRelativeFrame
      include PartComponents::HasYearOfScheme
      include Precisions::HasYearOfSchemePrecision
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


    class YearOfScheme_Month < SchemeRelativeFrame
      include PartComponents::HasYearOfScheme
      include PartComponents::HasMonthOfYear
      include Precisions::HasMonthOfSchemePrecision
    end

    class YearOfScheme_Quarter < SchemeRelativeFrame
      include PartComponents::HasYearOfScheme
      include PartComponents::HasQuarterOfYear
      include Precisions::HasQuarterOfSchemePrecision
    end

    class YearOfScheme_Quarter_Month < SchemeRelativeFrame
      include PartComponents::HasYearOfScheme
      include PartComponents::HasQuarterOfYear
      include PartComponents::HasMonthOfQuarter
      include Precisions::HasMonthOfSchemePrecision
    end

  end

end
