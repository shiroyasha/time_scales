require 'time'
require 'time_scales/frame/part_def'
require 'time_scales/frame/part_defs'
require 'time_scales/frame/base'
require 'time_scales/frame/null_frame'
require 'time_scales/frame/scheme_relative_frame'
require 'time_scales/frame/part_components'
require 'time_scales/frame/precisions'
require 'time_scales/frame/type_builder'

module TimeScales

  module Frame

    class << self
      def type_for(*part_keys)
        return Frame::NullFrame if part_keys.empty?

        part_defs = PartDefs.from_key_value_map( part_keys )
        type_for_parts( part_defs.parts )
      end

      def [](frame_parts = {})
        return Frame::NullFrame.instance if frame_parts.keys.empty?

        part_defs = PartDefs.from_key_value_map( frame_parts )
        instance_for_part_defs( part_defs )
      end

      private

      def type_for_parts(parts)
        return Frame::NullFrame if parts.empty?
        builder = TypeBuilder.new(parts)
        builder.call
      end

      def instance_for_part_defs(defs)
        type = type_for_parts( defs.parts )
        type.new( *defs.part_values )
      end
    end

    class NullFrame < Frame::Base
      include Singleton
    end

  end

end
