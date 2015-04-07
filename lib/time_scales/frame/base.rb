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

        private

        def _parts
          []
        end
      end

      def initialize(*args)
        _initialize args
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
