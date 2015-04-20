module TimeScales

  class TimeStruct < Struct.new(
    :year,
    :month,
    :day,
    :hour,
    :minute,
  )

    def normalize
      return unless year && day
      self.month ||= 1
      if month == 1 && day > 31
        self.month = 2
        self.day -= 31
      end
      feb_days = days_in_feb_of_year
      if month == 2 && day > feb_days
        self.month = 3
        self.day -= feb_days
      end
      if month == 3 && day > 31
        self.month  = 4
        self.day -= 31
      end
      if month == 4 && day > 30
        self.month = 5
        self.day -= 30
      end
      if month == 5 && day > 31
        self.month = 6
        self.day -= 31
      end
      if month == 6 && day > 30
        self.month = 7
        self.day -= 30
      end
      if month == 7 && day > 31
        self.month = 8
        self.day -= 31
      end
      if month == 8 && day > 31
        self.month = 9
        self.day -= 31
      end
      if month == 9 && day > 30
        self.month = 10
        self.day -= 30
      end
      if month == 10 && day > 31
        self.month = 11
        self.day -= 31
      end
      if month == 11 && day > 30
        self.month = 12
        self.day -= 30
      end
    end

    def days_in_feb_of_year
      t = Time.new(year, 3, 1)
      t.yday - 32
    end

  end

end
