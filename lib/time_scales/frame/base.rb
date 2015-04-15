module TimeScales
  module Frame

    class Base

      class << self
        def parts
          @parts ||=
            _parts.
            sort_by { |part| -part.scale }.
            freeze
        end

        def &(time)
          part_values = parts.map { |part|
            part & time
          }
          new( *part_values )
        end

        private

        def _parts
          []
        end
      end

      def initialize(*args)
        _initialize args
      end

      def parts
        @parts ||= Hash[
          self.class.parts.map { |part|
            [ part.symbol, send(part.symbol) ]
          }
        ]
        @parts.dup
      end

      def ==(other)
        self.class == other.class &&
          self._to_a == other._to_a
      end

      def to_a
        _to_a.dup
      end

      protected

      def _to_a
        @to_a ||= self.class.parts.map{ |part|
          send( part.symbol )
        }.freeze
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

  end
end
