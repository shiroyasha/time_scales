module TimeScales

  module Frame

    class TypeBuilder
      attr_reader :parts

      def initialize(parts)
        @parts = parts
      end

      def call
        _parts = parts ; _is_scheme_scoped = scheme_scoped?
        klass = Class.new type_base_class do
          _parts.each do |part| ; include part.component_mixin ; end
          include _parts.last.scheme_scoped_precision_mixin if _is_scheme_scoped
        end
        Frame.const_set type_const_name, klass
        klass
      end

      def type_base_class
        if scheme_scoped?
          Frame::SchemeRelativeFrame
        else
          Frame::Base
        end
      end

      def scheme_scoped?
        parts.first.scope == Units::Scheme
      end

      def type_const_name
        const_name = "#{parts.first.name}"
        parts[1..-1].each do |part| ; const_name << "_#{part.subdivision_name}" ; end
        const_name << 'Only' if parts.length == 1
        const_name << '__Auto'
      end
    end

  end

end
