module TimeScales
  module Frame

    class SchemeRelativeFrame < Frame::Base
      def to_range
        @to_range ||= ( begin_time...succ_begin_time )
      end

      def begin_time
        @begin_time ||= Time.new( *begin_time_struct.to_a )
      end

      alias to_time begin_time

      def succ_begin_time
        raise NotImplementedError, "Subclass responsibility"
      end
    end

  end
end
