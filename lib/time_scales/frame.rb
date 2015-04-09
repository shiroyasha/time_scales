require 'time'
require 'time_scales/frame/part_spec'
require 'time_scales/frame/part_specs'
require 'time_scales/frame/base'
require 'time_scales/frame/scheme_relative_frame'
require 'time_scales/frame/part_components'
require 'time_scales/frame/precisions'

module TimeScales

  module Frame

    class << self
      def type_for(*part_keys)
        return Frame::NullFrame if part_keys.empty?

        part_specs = PartSpecs.from_key_value_map( part_keys )
        part_specs.to_frame_type
      end

      def [](frame_parts = {})
        return Frame::NullFrame.instance if frame_parts.keys.empty?

        part_specs = PartSpecs.from_key_value_map( frame_parts )
        part_specs.to_frame
      end

      def frame_types
        @frame_types ||=
          constants.
          map { |c_name| const_get(c_name) }.
          select { |c_value| Class === c_value }.
          select { |c_class| c_class.ancestors.include?( Frame::Base ) }.
          reject { |frame_class| frame_class == Frame::Base }
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
