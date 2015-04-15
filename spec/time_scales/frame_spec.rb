require 'spec_helper'

module TimeScales

  describe Frame do
    describe '::type_for' do
      it "builds a type for a list of part keys in arbitrary order" do
        type = described_class.type_for(
          Units::Day,
          :quarter,
          Parts::MonthOfQuarter,
        )
        expect( type.parts ).to eq( [
          Parts::QuarterOfYear,
          Parts::MonthOfQuarter,
          Parts::DayOfMonth
        ] )
      end
    end

    describe '::[]' do
      it "builds an instance for a hash of values by part-key" do
        frame = described_class[
          Parts::YearOfScheme => 2012,
          Units::Month => 9,
          :day_of_month => 24
        ]
        expect( frame.parts ).to eq( {
          year_of_scheme: 2012,
          month_of_year: 9,
          day_of_month: 24
        } )
      end
    end

    it "is equal and hash-key-equal to another instance with same parts and part values" do
      actual_a   = described_class[ year: 2010, month: 10 ]
      expected_a = described_class[ year: 2010, month: 10 ]
      expect( actual_a ).to  eq( expected_a )
      expect( actual_a ).to eql( expected_a )
      expect( actual_a.hash ).to eql( expected_a.hash )


      actual_b   = described_class[ day: 21 ]
      expected_b = described_class[ day: 21 ]
      expect( actual_b ).to  eq( expected_b )
      expect( actual_b ).to eql( expected_b )
      expect( actual_b.hash ).to eql( expected_b.hash )
    end

    it "is not equal to another instance with different parts" do
      actual_a   = described_class[ year: 2010, month: 10 ]
      expected_a = described_class[ year: 2010 ]
      expect( actual_a ).not_to  eq( expected_a )
      expect( actual_a ).not_to eql( expected_a )

      actual_b   = described_class[ day: 21 ]
      expected_b = described_class[ month: 9, day: 21 ]
      expect( actual_b ).not_to  eq( expected_b )
      expect( actual_b ).not_to eql( expected_b )

      actual_c   = described_class[ quarter: 3, month: 2 ]
      expected_c = described_class[ month: 3, day: 2 ]
      expect( actual_c ).not_to  eq( expected_c )
      expect( actual_c ).not_to eql( expected_c )
    end

    it "is not equal to another instance with any differing values for same parts" do
      actual_a   = described_class[ year: 2010, month: 10 ]
      expected_a = described_class[ year: 2011, month: 10 ]
      expect( actual_a ).not_to  eq( expected_a )
      expect( actual_a ).not_to eql( expected_a )

      actual_b   = described_class[ month: 9, day: 21 ]
      expected_b = described_class[ month: 9, day: 22 ]
      expect( actual_b ).not_to  eq( expected_b )
      expect( actual_b ).not_to eql( expected_b )
    end

    context "with a year-of-scheme part" do
      let( :type ) {
        described_class.type_for( :year_of_scheme )
      }

      it "rejects construction with a non-Fixnum year value" do
        expect{ type.new( '2014'  ) }.to raise_error( ArgumentError )
        expect{ type.new(  2014.0 ) }.to raise_error( ArgumentError )
        expect{ type.new(  nil    ) }.to raise_error( ArgumentError )
      end

      it "exposes its year value as #year_of_scheme and #year" do
        frame = type.new( 2014 )
        expect( frame.year_of_scheme ).to eq( 2014 )
        expect( frame.year           ).to eq( 2014 )
      end

      it "can be built from a time" do
        frame = type & Time.new( 2009, 10, 20 )
        expected_frame = type.new( 2009 )
        expect( frame ).to eq( expected_frame )
      end
    end

    context "with a scope of Scheme and a precision of Year" do
      let( :frame ) {
        described_class[ year_of_scheme: 2013 ]
      }

      it "is convertible to the time at the start of the year" do
        expect( frame.to_time ).to eq( Time.new(2013, 1, 1, 0, 0, 0) )
      end

      it "is convertible to range from year start until (but not including) next year start" do
        frame_start      = Time.new(2013, 1, 1, 0, 0, 0)
        next_frame_start = Time.new(2014, 1, 1, 0, 0, 0)
        expect( frame.to_range ).to eq( frame_start...next_frame_start )
      end
    end

    context "with a quarter-of-year part" do
      let( :type ) {
        described_class.type_for( :quarter_of_year )
      }

      it "rejects construction with a non-Fixnum quarter value" do
        expect{ type.new( '3'  ) }.to raise_error( ArgumentError )
        expect{ type.new(  3.0 ) }.to raise_error( ArgumentError )
        expect{ type.new(  nil ) }.to raise_error( ArgumentError )
      end

      it "exposes its month as #quarter_of_year and #quarter" do
        frame = type.new( 2 )
        expect( frame.quarter_of_year ).to eq( 2 )
        expect( frame.quarter         ).to eq( 2 )
      end

      it "can be built from a time" do
        frame = type & Time.new( 2009, 6, 15 )
        expected_frame = type.new( 2 )
        expect( frame ).to eq( expected_frame )
      end
    end

    context "with a scope of scheme and a precision of quarter" do
      let( :frame_a ) {
        described_class[ year_of_scheme: 2013, quarter_of_year: 2 ]
      }
      let( :frame_b ) {
        described_class[ year_of_scheme: 2011, quarter_of_year: 4 ]
      }

      it "is convertible to the time at the start of the quarter" do
        expect( frame_a.to_time ).to eq( Time.new(2013, 4, 1, 0, 0, 0) )
      end

      it "is convertible to range from year start until (but not including) next year start" do
        frame_a_start      = Time.new(2013, 4, 1, 0, 0, 0)
        frame_a_next_start = Time.new(2013, 7, 1, 0, 0, 0)
        expect( frame_a.to_range ).to eq( frame_a_start...frame_a_next_start )

        frame_b_start      = Time.new(2011, 10, 1, 0, 0, 0)
        frame_b_next_start = Time.new(2012,  1, 1, 0, 0, 0)
        expect( frame_b.to_range ).to eq( frame_b_start...frame_b_next_start )
      end
    end

    context "with a month-of-year part" do
      let( :type ) {
        described_class.type_for( :month_of_year )
      }

      it "rejects construction with a non-Fixnum month value" do
        expect{ type.new( '11'  ) }.to raise_error( ArgumentError )
        expect{ type.new(  11.0 ) }.to raise_error( ArgumentError )
        expect{ type.new(  nil  ) }.to raise_error( ArgumentError )
      end

      it "exposes its year month as #month_of_year and #month" do
        frame = type.new( 9 )
        expect( frame.month_of_year ).to eq( 9 )
        expect( frame.month         ).to eq( 9 )
      end

      it "can be built from a time" do
        frame = type & Time.new( 2009, 5, 15 )
        expected_frame = type.new( 5 )
        expect( frame ).to eq( expected_frame )
      end
    end

    context "with a month-of-quarter part" do
      let( :type ) {
        described_class.type_for( :month_of_quarter )
      }

      it "rejects construction with a non-Fixnum month value" do
        expect{ type.new( '3'  ) }.to raise_error( ArgumentError )
        expect{ type.new(  3.0 ) }.to raise_error( ArgumentError )
        expect{ type.new(  nil ) }.to raise_error( ArgumentError )
      end

      it "exposes its month as #month_of_quarter and #month" do
        frame = type.new( 2 )
        expect( frame.month_of_quarter ).to eq( 2 )
        expect( frame.month            ).to eq( 2 )
      end

      it "can be built from a time" do
        frame = type & Time.new( 2009, 6, 15 )
        expected_frame = type.new( 3 )
        expect( frame ).to eq( expected_frame )
      end
    end

    context "with a scope of Scheme and a precision of Month" do
      let( :frame_a ) {
        described_class[ year_of_scheme: 2013, month_of_year: 10 ]
      }
      let( :frame_b ) {
        described_class[ year_of_scheme: 2015, quarter: 4, month_of_quarter: 3 ]
      }

      it "is convertible to the time at the start of the month" do
        expect( frame_a.to_time ).to eq( Time.new(2013, 10, 1, 0, 0, 0) )
        expect( frame_b.to_time ).to eq( Time.new(2015, 12, 1, 0, 0, 0) )
      end

      it "is convertible to range from year start until (but not including) next year start" do
        frame_a_start      = Time.new(2013, 10, 1, 0, 0, 0)
        frame_a_next_start = Time.new(2013, 11, 1, 0, 0, 0)
        expect( frame_a.to_range ).to eq( frame_a_start...frame_a_next_start )

        frame_b_start      = Time.new(2015, 12, 1, 0, 0, 0)
        frame_b_next_start = Time.new(2016,  1, 1, 0, 0, 0)
        expect( frame_b.to_range ).to eq( frame_b_start...frame_b_next_start )
      end
    end

    context "with a day_of_month part" do
      let( :type ) {
        described_class.type_for( :day_of_month )
      }

      it "rejects construction with a non-Fixnum day value" do
        expect{ type.new( '22'  ) }.to raise_error( ArgumentError )
        expect{ type.new(  22.0 ) }.to raise_error( ArgumentError )
        expect{ type.new(  nil  ) }.to raise_error( ArgumentError )
      end

      it "exposes its month as #day_of_month and #day" do
        frame = type.new( 24 )
        expect( frame.day_of_month ).to eq( 24 )
        expect( frame.day          ).to eq( 24 )
      end

      it "can be built from a time" do
        frame = type & Time.new( 2009, 6, 15 )
        expected_frame = type.new( 15 )
        expect( frame ).to eq( expected_frame )
      end
    end

    context "with a day_of_year part" do
      let( :type ) {
        described_class.type_for( :day_of_year )
      }

      it "rejects construction with a non-Fixnum day value" do
        expect{ type.new( '200'  ) }.to raise_error( ArgumentError )
        expect{ type.new(  200.0 ) }.to raise_error( ArgumentError )
        expect{ type.new(  nil   ) }.to raise_error( ArgumentError )
      end

      it "exposes its day as #day_of_year and #day" do
        frame = type.new( 150 )
        expect( frame.day_of_year ).to eq( 150 )
        expect( frame.day         ).to eq( 150 )
      end

      it "can be built from a time" do
        frame = type & Time.new( 2013, 12, 26 )
        expected_frame = type.new( 360 )
        expect( frame ).to eq( expected_frame )
      end
    end

    context "with a scope of Scheme and a precision of Day" do
      let( :frame_a ) {
        described_class[ year_of_scheme: 2012, month: 10, day_of_month: 19 ]
      }
      let( :frame_b ) {
        described_class[ year_of_scheme: 2014, quarter: 4, month: 3, day_of_month: 31 ]
      }
      let( :frame_c ) {
        described_class[ year_of_scheme: 2015, day_of_year: 90 ]
      }

      it "is convertible to the time at the start of the day" do
        expect( frame_a.to_time ).to eq( Time.new(2012, 10, 19, 0, 0, 0) )
        expect( frame_b.to_time ).to eq( Time.new(2014, 12, 31, 0, 0, 0) )
        expect( frame_c.to_time ).to eq( Time.new(2015,  3, 31, 0, 0, 0) )
      end

      it "is convertible to range from day start until (but not including) next day start" do
        frame_a_start      = Time.new(2012, 10, 19, 0, 0, 0)
        frame_a_next_start = Time.new(2012, 10, 20, 0, 0, 0)
        expect( frame_a.to_range ).to eq( frame_a_start...frame_a_next_start )

        frame_b_start      = Time.new(2014, 12, 31, 0, 0, 0)
        frame_b_next_start = Time.new(2015,  1,  1, 0, 0, 0)
        expect( frame_b.to_range ).to eq( frame_b_start...frame_b_next_start )

        frame_c_start      = Time.new(2015,  3, 31, 0, 0, 0)
        frame_c_next_start = Time.new(2015,  4,  1, 0, 0, 0)
        expect( frame_b.to_range ).to eq( frame_b_start...frame_b_next_start )
      end
    end

    context "with several parts" do
      let( :type ) {
        described_class.type_for( :quarter_of_year, :month_of_quarter, :day_of_month )
      }

      it "can be built from a time" do
        frame = type & Time.new( 2011, 7, 17 )
        expected_frame = type.new( 3, 1, 17 )
        expect( frame ).to eq( expected_frame )
      end
    end
  end

end
