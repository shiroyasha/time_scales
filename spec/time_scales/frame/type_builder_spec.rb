require 'spec_helper'

module TimeScales

  describe Frame::TypeBuilder do
    let( :built_type ) { subject.call }

    context "for just a YearOfScheme part" do
      subject{
        described_class.new( [Parts::YearOfScheme] )
      }
      it "produces a frame type with a year_of_scheme property" do
        instance = built_type.new( 2010 )
        expect( instance.year_of_scheme ).to eq( 2010 )
      end
    end

    context "for just a QuarterOfYear part" do
      subject{
        described_class.new( [Parts::QuarterOfYear] )
      }
      it "produces a frame type with a quarter_of_year property" do
        instance = built_type.new( 3 )
        expect( instance.quarter_of_year ).to eq( 3 )
      end
    end

    context "for just a MonthOfYear part" do
      subject{
        described_class.new( [Parts::MonthOfYear] )
      }
      it "produces a frame type with a month_of_year property" do
        instance = built_type.new( 11 )
        expect( instance.month_of_year ).to eq( 11 )
      end
    end

    context "for just a MonthOfQuarter part" do
      subject{
        described_class.new( [Parts::MonthOfQuarter] )
      }
      it "produces a frame type with a month_of_quarter property" do
        instance = built_type.new( 2 )
        expect( instance.month_of_quarter ).to eq( 2 )
      end
    end

    context "for just a DayOfMonth part" do
      subject{
        described_class.new( [Parts::DayOfMonth] )
      }
      it "produces a frame type with a day_of_month property" do
        instance = built_type.new( 25 )
        expect( instance.day_of_month ).to eq( 25 )
      end
    end

    context "for YearOfScheme and MonthOfYear parts" do
      subject{
        described_class.new( [Parts::YearOfScheme, Parts::MonthOfYear] )
      }
      it "produces a frame type with a year_of_scheme and month_of_year properties" do
        instance = built_type.new( 2005, 27 )
        expect( instance.year_of_scheme ).to eq( 2005 )
        expect( instance.month_of_year ).to eq( 27 )
      end
    end

    context "for MonthOfYear and DayOfMonth parts" do
      subject{
        described_class.new( [Parts::MonthOfYear, Parts::DayOfMonth] )
      }
      it "produces a frame type with a month_of_year and day_of_month properties" do
        instance = built_type.new( 10, 22 )
        expect( instance.month_of_year ).to eq( 10 )
        expect( instance.day_of_month ).to eq( 22 )
      end
    end

    context "for YearOfScheme, QuarterOfYear ... DayOfMonth parts" do
      subject{
        described_class.new( [
          Parts::YearOfScheme,
          Parts::QuarterOfYear,
          Parts::MonthOfQuarter,
          Parts::DayOfMonth
        ] )
      }
      it "produces a frame type with a year_of_scheme, quarter_of_year ... day_of_month properties" do
        instance = built_type.new( 2015, 4, 2, 16 )
        expect( instance.year_of_scheme ).to eq( 2015 )
        expect( instance.quarter_of_year ).to eq( 4 )
        expect( instance.month_of_quarter ).to eq( 2 )
        expect( instance.day_of_month ).to eq( 16 )
      end
    end

  end

end
