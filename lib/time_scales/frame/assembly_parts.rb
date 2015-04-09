module TimeScales
  module Frame

    class AssemblyParts

      class << self
        private :new

        def from_key_value_map(kvm)
          faps = kvm.map { |key, value|
            AssemblyPart.new( key, value )
          }
          new( faps )
        end
      end

      def initialize(faps)
        @faps = faps
      end

      def parts
        @parts ||= assembly_sequence.map { |fap| fap.part }
      end

      def values
        assembly_sequence.map { |fap| fap.value }
      end

      private

      attr_reader :faps

      def assembly_sequence
        return [] if faps.empty?
        @assembly_sequence ||= begin
          seq = faps.sort_by { |fap| -fap.scale }
          seq.first.outer_scope!
          seq[0..-2].zip( seq[1..-1] ).each do |a,b|
            b.component_of! a.part
          end
          seq
        end
      end

    end

  end
end
