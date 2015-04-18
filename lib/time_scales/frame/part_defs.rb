module TimeScales
  module Frame

    class PartDefs

      class << self
        private :new

        def from_key_value_map(kvm)
          part_defs = kvm.map { |part_key, value|
            PartDef.new( part_key, value )
          }
          new( part_defs )
        end

        def from_keys(part_keys)
          part_defs = part_keys.map { |key| PartDef.new(key) }
          new( part_defs )
        end
      end

      def initialize(part_defs)
        @part_defs = part_defs
      end

      def parts
        @parts ||= assembly_sequence.map { |pd| pd.part }
      end

      def part_values
        assembly_sequence.map { |pd| pd.value }
      end

      private

      attr_reader :part_defs

      def assembly_sequence
        return [] if part_defs.empty?
        @assembly_sequence ||= begin
          seq = part_defs.sort_by { |ps| -ps.scale }
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
