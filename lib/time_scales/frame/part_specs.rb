module TimeScales
  module Frame

    class PartSpecs

      class << self
        private :new

        def from_key_value_map(kvm)
          part_specs = kvm.map { |part_key, value|
            PartSpec.new( part_key, value )
          }
          new( part_specs )
        end

        def from_keys(part_keys)
          part_specs = part_keys.map { |key| PartSpec.new(key) }
          new( part_specs )
        end
      end

      def initialize(part_specs)
        @part_specs = part_specs
      end

      def parts
        @parts ||= assembly_sequence.map { |ps| ps.part }
      end

      def part_values
        assembly_sequence.map { |ps| ps.value }
      end

      private

      attr_reader :part_specs

      def assembly_sequence
        return [] if part_specs.empty?
        @assembly_sequence ||= begin
          seq = part_specs.sort_by { |ps| -ps.scale }
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
