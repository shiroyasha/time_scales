module TimeScales
  module Frame

    class SchemeRelativeFrame < Frame::Base
      def to_time
        begin_time
      end

      def to_range
        @to_range ||= ( begin_time...succ_begin_time )
      end

      def begin_time
        @begin_time = begin
          struct = TimeStruct.new
          prepare_time_struct struct
          struct.normalize
          Time.new( *struct.to_a )
        end
      end

      def succ_begin_time
        raise NotImplementedError, "Subclass responsibility"
      end

      private

      def prepare_time_struct(struct)
        # stub
      end
    end

  end
end
