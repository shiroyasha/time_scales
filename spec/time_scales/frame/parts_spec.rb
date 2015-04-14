require 'spec_helper'

module TimeScales

  context do
    let( :_59_and_a_half ) {
      Rational( 119, 2 )
    }

    describe Parts::YearOfScheme do
      describe '#&' do
        it "Extracts the year component from the given time" do
          expect( subject & Time.new(2010,  1,  1,  0,  0,   0            ) ).to eq( 2010 )
          expect( subject & Time.new(2012, 12, 31, 23, 59, _59_and_a_half ) ).to eq( 2012 )
        end
      end
    end

    describe Parts::QuarterOfYear do
      describe '#&' do
        it "Extracts the quarter part value from the given time" do
          expect( subject & Time.new(2010,  1,  1,  0,  0,   0            ) ).to eq( 1 )
          expect( subject & Time.new(2010,  5, 16,  0,  0,   0            ) ).to eq( 2 )
          expect( subject & Time.new(2012, 12, 31, 23, 59, _59_and_a_half ) ).to eq( 4 )
        end
      end
    end

    describe Parts::MonthOfYear do
      describe '#&' do
        it "Extracts the month component from the given time" do
          expect( subject & Time.new(2010,  1,  1,  0,  0,   0            ) ).to eq(  1 )
          expect( subject & Time.new(2010,  5, 16,  0,  0,   0            ) ).to eq(  5 )
          expect( subject & Time.new(2012, 12, 31, 23, 59, _59_and_a_half ) ).to eq( 12 )
        end
      end
    end

    describe Parts::MonthOfQuarter do
      describe '#&' do
        it "Extracts the month-of-quarter value from the given time" do
          expect( subject & Time.new(2010,  1,  1,  0,  0,   0            ) ).to eq( 1 )
          expect( subject & Time.new(2010,  5, 16,  0,  0,   0            ) ).to eq( 2 )
          expect( subject & Time.new(2012, 12, 31, 23, 59, _59_and_a_half ) ).to eq( 3 )
        end
      end
    end

    describe Parts::DayOfMonth do
      describe '#&' do
        it "Extracts the day component from the given time" do
          expect( subject & Time.new(2010,  1,  1,  0,  0,   0            ) ).to eq(  1 )
          expect( subject & Time.new(2010,  5, 16,  0,  0,   0            ) ).to eq( 16 )
          expect( subject & Time.new(2012, 12, 31, 23, 59, _59_and_a_half ) ).to eq( 31 )
        end
      end
    end
  end

end
