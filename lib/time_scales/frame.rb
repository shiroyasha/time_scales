module TimeScales

  class Frame
    def self.[](parts)
      new(parts)
    end

    def initialize(parts)
      @year_of_scheme = parts[:year]
    end

    attr_reader :year_of_scheme

    def year
      year_of_scheme
    end
  end

end
