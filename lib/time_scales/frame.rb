require 'time'

module TimeScales

  class Frame
    def self.[](parts)
      new(parts)
    end

    def initialize(parts)
      @year_of_scheme = ensure_fixnum( parts[:year] )
    end

    attr_reader :year_of_scheme

    def year
      year_of_scheme
    end

    def to_time
      begin_time
    end

    def to_range
      @to_range ||= ( begin_time...succ_begin_time )
    end

    def begin_time
      @begin_time ||= Time.new( year_of_scheme )
    end

    def succ_begin_time
      @end_time ||= Time.new( year_of_scheme + 1 )
    end

    private

    def ensure_fixnum(value)
      return value if Fixnum === value
      raise ArgumentError, "Time part value must be of Fixnum type (a numeric integer)"
    end
  end

end
