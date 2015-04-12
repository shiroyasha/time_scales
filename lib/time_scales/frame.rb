require 'time'
require 'time_scales/frame/part_spec'
require 'time_scales/frame/part_specs'
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

        part_specs = PartSpecs.from_key_value_map( part_keys )
        type_for_parts( part_specs.parts )
      end

      def [](frame_parts = {})
        return Frame::NullFrame.instance if frame_parts.keys.empty?

        part_specs = PartSpecs.from_key_value_map( frame_parts )
        instance_for_part_specs( part_specs )
      end

      def frame_types
        @frame_types ||=
          constants.
          map { |c_name| const_get(c_name) }.
          select { |c_value| Class === c_value }.
          select { |c_class| c_class.ancestors.include?( Frame::Base ) }.
          reject { |frame_class| frame_class == Frame::Base }
      end

      def type_for_parts(parts)
        return Frame::NullFrame if parts.empty?
        type_cache.fetch(parts) {
          builder = TypeBuilder.new(parts)
          type_cache[parts] = builder.call
        }
      end

      def instance_for_part_specs(specs)
        type = type_for_parts( specs.parts )
        type.new( *specs.part_values )
      end

      private

      def type_cache
        @type_cache ||= {}
      end
    end

    class NullFrame < Frame::Base
      include Singleton
    end

  end

end
