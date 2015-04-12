require 'spec_helper'

module TimeScales

  describe Frame do
    describe '::type_for' do
      it "returns appropriate type for a year-of-scheme key" do
        expected_parts = [ Parts::YearOfScheme ]

        expect(
          subject.type_for( Parts::YearOfScheme ).parts
        ).to eq( expected_parts )

        expect(
          subject.type_for( :year_of_scheme ).parts
        ).to eq( expected_parts )

        expect(
          subject.type_for( :year ).parts
        ).to eq( expected_parts )
      end

      it "returns appropriate type for a month-of-year identifier" do
        expected_parts = [ Parts::MonthOfYear ]

        expect(
          subject.type_for( Parts::MonthOfYear ).parts
        ).to eq( expected_parts )

        expect(
          subject.type_for( :month_of_year ).parts
        ).to eq( expected_parts )

        expect(
          subject.type_for( :month ).parts
        ).to eq( expected_parts )
      end

      it "returns appropriate type for a year-of-scheme / month identifiers" do
        expected_parts = [ Parts::YearOfScheme, Parts::MonthOfYear ]

        expect(
          subject.type_for( Parts::YearOfScheme, Parts::MonthOfYear ).parts
        ).to eq( expected_parts )

        expect(
          subject.type_for( :year_of_scheme, :month ).parts
        ).to eq( expected_parts )

        expect(
          subject.type_for( :year, :month_of_year ).parts
        ).to eq( expected_parts )
      end

      it "returns appropriate type for a quarter-of-year identifier" do
        expected_parts = [ Parts::QuarterOfYear ]

        expect(
          subject.type_for( Parts::QuarterOfYear ).parts
        ).to eq( expected_parts )

        expect(
          subject.type_for( :quarter_of_year ).parts
        ).to eq( expected_parts )

        expect(
          subject.type_for( :quarter ).parts
        ).to eq( expected_parts )
      end

      it "returns appropriate type for a year-of-scheme / quarter / month identifiers" do
        expected_parts = [
          Parts::YearOfScheme,
          Parts::QuarterOfYear,
          Parts::MonthOfQuarter,
        ]

        expect(
          subject.type_for(
            Parts::YearOfScheme,
            Parts::QuarterOfYear,
            Parts::MonthOfQuarter,
          ).parts
        ).to eq( expected_parts )

        expect(
          subject.type_for( :year_of_scheme, :quarter_of_year, :month ).parts
        ).to eq( expected_parts )

        expect(
          subject.type_for( :year, :quarter, :month_of_quarter ).parts
        ).to eq( expected_parts )
      end

      it "returns appropriate type for a day-of-month identifier" do
        expected_parts = [ Parts::DayOfMonth ]

        expect(
          subject.type_for( Parts::DayOfMonth ).parts
        ).to eq( expected_parts )

        expect(
          subject.type_for( :day_of_month ).parts
        ).to eq( expected_parts )

        expect(
          subject.type_for( :day ).parts
        ).to eq( expected_parts )
      end
    end

    context "an instance with no parts" do
      subject { described_class[] }

      it "has no year-part attributes" do
        expect( subject ).not_to respond_to( :year )
        expect( subject.methods.grep( /^year_of/ ) ). to be_empty
      end

      it "has no month-part attributes" do
        expect( subject ).not_to respond_to( :month )
        expect( subject.methods.grep( /^month_of/ ) ). to be_empty
      end

      it "has no quarter-part attributes" do
        expect( subject ).not_to respond_to( :quarter )
        expect( subject.methods.grep( /^quarter_of/ ) ). to be_empty
      end
    end

    it "rejects construction with a non-Fixnum year value" do
      expect{ described_class[year: '2010'] }.to raise_error( ArgumentError )
      expect{ described_class[year: 2010.0] }.to raise_error( ArgumentError )
      expect{ described_class[year: nil]    }.to raise_error( ArgumentError )
    end

    context "an instance for a specific year" do
      subject { described_class[year: 2014] }

      it "exposes its year through its #year_of_scheme property" do
        expect( subject.year_of_scheme ).to eq( 2014 )
      end

      it "exposes its year through its #year property" do
        expect( subject.year ).to eq( 2014 )
      end

      it "is convertible to the time at the start of the year" do
        expect( subject.to_time ).to eq( Time.new(2014, 1, 1, 0, 0, 0) )
      end

      it "is convertible to range from year start until (but not including) next year start" do
        frame_start      = Time.new(2014, 1, 1, 0, 0, 0)
        next_frame_start = Time.new(2015, 1, 1, 0, 0, 0)
        expect( subject.to_range ).to eq( frame_start...next_frame_start )
      end
    end

    it "rejects construction with a non-Fixnum month value" do
      expect{ described_class[month: '10'] }.to raise_error( ArgumentError )
      expect{ described_class[month: 11.0] }.to raise_error( ArgumentError )
      expect{ described_class[month: nil]  }.to raise_error( ArgumentError )
    end

    context "an instance for a specific month" do
      subject { described_class[month: 11] }

      it "exposes its month through its #month_of_year property" do
        expect( subject.month_of_year ).to eq( 11 )
      end

      it "exposes its month through its #month property" do
        expect( subject.month ).to eq( 11 )
      end

      it "is not convertible to a time or a range" do
        expect( subject ).not_to respond_to( :to_time )
        expect( subject ).not_to respond_to( :to_range )
      end
    end

    it "rejects construction with a non-Fixnum quarter value" do
      expect{ described_class[quarter: '3'] }.to raise_error( ArgumentError )
      expect{ described_class[quarter: 4.0] }.to raise_error( ArgumentError )
      expect{ described_class[quarter: nil] }.to raise_error( ArgumentError )
    end

    context "an instance for a specific quarter" do
      subject { described_class[quarter: 3] }

      it "exposes its quarter through its #quarter_of_year property" do
        expect( subject.quarter_of_year ).to eq( 3 )
      end

      it "exposes its quarter through its #quarter property" do
        expect( subject.quarter ).to eq( 3 )
      end

      it "is not convertible to a time or a range" do
        expect( subject ).not_to respond_to( :to_time )
        expect( subject ).not_to respond_to( :to_range )
      end
    end

    it "rejects construction with a non-Fixnum month_of_quarter value" do
      expect{ described_class[month_of_quarter: '3'] }.to raise_error( ArgumentError )
      expect{ described_class[month_of_quarter: 2.0] }.to raise_error( ArgumentError )
      expect{ described_class[month_of_quarter: nil] }.to raise_error( ArgumentError )
    end

    context "an instance for a specific month of quarter" do
      subject { described_class[month_of_quarter: 2] }

      it "exposes its quarter through its #month_of_quarter property" do
        expect( subject.month_of_quarter ).to eq( 2 )
      end

      it "exposes its quarter through its #month property" do
        expect( subject.month ).to eq( 2 )
      end

      it "is not convertible to a time or a range" do
        expect( subject ).not_to respond_to( :to_time )
        expect( subject ).not_to respond_to( :to_range )
      end
    end

    context "an instance for a specific year and quarter" do
      subject           { described_class[year: 1998, quarter: 3] }
      let( :subject_2 ) { described_class[year: 2010, quarter: 4] }

      it "exposes its year through its #year_of_scheme property" do
        expect( subject.year_of_scheme ).to eq( 1998 )
      end

      it "exposes its year through its #year property" do
        expect( subject.year ).to eq( 1998 )
      end

      it "exposes its quarter through its #quarter_of_year property" do
        expect( subject.quarter_of_year ).to eq( 3 )
      end

      it "exposes its quarter through its #quarter property" do
        expect( subject.quarter ).to eq( 3 )
      end

      it "is convertible to the time at the start of the quarter" do
        expect( subject.to_time ).to eq( Time.new(1998, 7, 1, 0, 0, 0) )
      end

      it "is convertible to range from month start until (but not including) next month start" do
        frame_start      = Time.new(1998, 7, 1, 0, 0, 0)
        next_frame_start = Time.new(1998, 10, 1, 0, 0, 0)
        expect( subject.to_range ).to eq( frame_start...next_frame_start )

        frame_start      = Time.new(2010, 10, 1, 0, 0, 0)
        next_frame_start = Time.new(2011,  1, 1, 0, 0, 0)
        expect( subject_2.to_range ).to eq( frame_start...next_frame_start )
      end
    end

    context "an instance for a specific year and month" do
      subject           { described_class[year: 2001, month: 10] }
      let( :subject_2 ) { described_class[year: 2015, month: 12] }

      it "exposes its year through its #year_of_scheme property" do
        expect( subject.year_of_scheme ).to eq( 2001 )
      end

      it "exposes its year through its #year property" do
        expect( subject.year ).to eq( 2001 )
      end

      it "exposes its month through its #month_of_year property" do
        expect( subject.month_of_year ).to eq( 10 )
      end

      it "exposes its month through its #month property" do
        expect( subject.month ).to eq( 10 )
      end

      it "is convertible to the time at the start of the month" do
        expect( subject.to_time ).to eq( Time.new(2001, 10, 1, 0, 0, 0) )
      end

      it "is convertible to range from month start until (but not including) next month start" do
        frame_start      = Time.new(2001, 10, 1, 0, 0, 0)
        next_frame_start = Time.new(2001, 11, 1, 0, 0, 0)
        expect( subject.to_range ).to eq( frame_start...next_frame_start )

        frame_start      = Time.new(2015, 12, 1, 0, 0, 0)
        next_frame_start = Time.new(2016,  1, 1, 0, 0, 0)
        expect( subject_2.to_range ).to eq( frame_start...next_frame_start )
      end
    end

    context "an instance for a specific quarter and month (of quarter)" do
      subject           { described_class[quarter: 2, month:            3] }
      let( :subject_2 ) { described_class[quarter: 4, month_of_quarter: 2] }

      it "exposes its quarter through its #quarter_of_year property" do
        expect( subject.quarter_of_year   ).to eq( 2 )
        expect( subject_2.quarter_of_year ).to eq( 4 )
      end

      it "exposes its quarter through its #quarter property" do
        expect( subject.quarter   ).to eq( 2 )
        expect( subject_2.quarter ).to eq( 4 )
      end

      it "exposes its month through its #month_of_quarter property" do
        expect( subject.month_of_quarter   ).to eq( 3 )
        expect( subject_2.month_of_quarter ).to eq( 2 )
      end

      it "exposes its month through its #month property" do
        expect( subject.month   ).to eq( 3 )
        expect( subject_2.month ).to eq( 2 )
      end

      it "is not convertible to a time" do
        expect( subject   ).not_to respond_to( :to_time )
        expect( subject_2 ).not_to respond_to( :to_time )
      end

      it "is not convertible to a range" do
        expect( subject   ).not_to respond_to( :to_range )
        expect( subject_2 ).not_to respond_to( :to_range )
      end
    end

    context "an instance for a specific year, quarter, and month (of quarter)" do
      subject           { described_class[year: 1991, quarter: 2, month:            3] }
      let( :subject_2 ) { described_class[year: 1995, quarter: 3, month:            2] }
      let( :subject_3 ) { described_class[year: 1997, quarter: 4, month_of_quarter: 3] }

      it "exposes its year through its #year_of_scheme property" do
        expect( subject.year_of_scheme ).to eq( 1991 )
      end

      it "exposes its year through its #year property" do
        expect( subject.year ).to eq( 1991 )
      end

      it "exposes its quarter through its #quarter_of_year property" do
        expect( subject.quarter_of_year ).to eq( 2 )
      end

      it "exposes its quarter through its #quarter property" do
        expect( subject.quarter ).to eq( 2 )
      end

      it "exposes its month through its #month_of_quarter property" do
        expect( subject.month_of_quarter ).to eq( 3 )
      end

      it "exposes its month through its #month property" do
        expect( subject.month ).to eq( 3 )
      end


      it "is convertible to the time at the start of the month" do
        expect( subject.to_time ).to eq( Time.new(1991, 6, 1, 0, 0, 0) )
      end

      it "is convertible to range from month start until (but not including) next month start" do
        frame_start      = Time.new(1991, 6, 1, 0, 0, 0)
        next_frame_start = Time.new(1991, 7, 1, 0, 0, 0)
        expect( subject.to_range ).to eq( frame_start...next_frame_start )

        frame_start      = Time.new(1995, 8, 1, 0, 0, 0)
        next_frame_start = Time.new(1995, 9, 1, 0, 0, 0)
        expect( subject_2.to_range ).to eq( frame_start...next_frame_start )

        frame_start      = Time.new(1997, 12, 1, 0, 0, 0)
        next_frame_start = Time.new(1998,  1, 1, 0, 0, 0)
        expect( subject_3.to_range ).to eq( frame_start...next_frame_start )
      end
    end

  end

end
