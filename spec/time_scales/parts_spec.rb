require 'spec_helper'

module TimeScales

  context do
    let( :_59_and_a_half ) {
      Rational( 119, 2 )
    }

    describe Parts::YearOfScheme do
      it "is included in the Parts::all collection" do
        expect( Parts.all ).to include( subject )
      end

      describe '#&' do
        it "Extracts the year component from the given time" do
          expect( subject & Time.new(2010,  1,  1,  0,  0,   0            ) ).to eq( 2010 )
          expect( subject & Time.new(2012, 12, 31, 23, 59, _59_and_a_half ) ).to eq( 2012 )
        end
      end
    end

    describe Parts::QuarterOfYear do
      it "is included in the Parts::all collection" do
        expect( Parts.all ).to include( subject )
      end

      describe '#&' do
        it "Extracts the quarter part value from the given time" do
          expect( subject & Time.new(2010,  1,  1,  0,  0,   0            ) ).to eq( 1 )
          expect( subject & Time.new(2010,  5, 16,  0,  0,   0            ) ).to eq( 2 )
          expect( subject & Time.new(2012, 12, 31, 23, 59, _59_and_a_half ) ).to eq( 4 )
        end
      end
    end

    describe Parts::MonthOfYear do
      it "is included in the Parts::all collection" do
        expect( Parts.all ).to include( subject )
      end

      describe '#&' do
        it "Extracts the month component from the given time" do
          expect( subject & Time.new(2010,  1,  1,  0,  0,   0            ) ).to eq(  1 )
          expect( subject & Time.new(2010,  5, 16,  0,  0,   0            ) ).to eq(  5 )
          expect( subject & Time.new(2012, 12, 31, 23, 59, _59_and_a_half ) ).to eq( 12 )
        end
      end
    end

    describe Parts::MonthOfQuarter do
      it "is included in the Parts::all collection" do
        expect( Parts.all ).to include( subject )
      end

      describe '#&' do
        it "Extracts the month-of-quarter value from the given time" do
          expect( subject & Time.new(2010,  1,  1,  0,  0,   0            ) ).to eq( 1 )
          expect( subject & Time.new(2010,  5, 16,  0,  0,   0            ) ).to eq( 2 )
          expect( subject & Time.new(2012, 12, 31, 23, 59, _59_and_a_half ) ).to eq( 3 )
        end
      end
    end

    describe Parts::DayOfMonth do
      it "is included in the Parts::all collection" do
        expect( Parts.all ).to include( subject )
      end

      describe '#&' do
        it "Extracts the day component from the given time" do
          expect( subject & Time.new(2010,  1,  1,  0,  0,   0            ) ).to eq(  1 )
          expect( subject & Time.new(2010,  5, 16,  0,  0,   0            ) ).to eq( 16 )
          expect( subject & Time.new(2012, 12, 31, 23, 59, _59_and_a_half ) ).to eq( 31 )
        end
      end
    end

    describe Parts::DayOfYear do
      it "is included in the Parts::all collection" do
        expect( Parts.all ).to include( subject )
      end

      describe '#&' do
        it "Extracts the day-of-year value from the given time" do
          expect( subject & Time.new(1998,  4,  1,  0,  0,   0            ) ).to eq(  91 )
          expect( subject & Time.new(2000,  4,  1,  0,  0,   0            ) ).to eq(  92 )
          expect( subject & Time.new(1998, 12, 31, 23, 59, _59_and_a_half ) ).to eq( 365 )
          expect( subject & Time.new(2000, 12, 31, 23, 59, _59_and_a_half ) ).to eq( 366 )
        end
      end
    end
  end

end
