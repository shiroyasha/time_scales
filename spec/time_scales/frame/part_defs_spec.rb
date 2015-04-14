require 'spec_helper'

module TimeScales

  describe Frame::PartDefs do
    it "produces an empty parts sequence for an empty key list" do
      defs = described_class.from_keys( [] )
      expect( defs.parts ).to eq( [] )
    end

    it "matches an outer-scope part from itself" do
      defs = described_class.from_keys( [Parts::YearOfScheme] )
      expect( defs.parts.first ).to eq( Parts::YearOfScheme )

      defs = described_class.from_keys(
        [Parts::MonthOfQuarter, Parts::QuarterOfYear]
      )
      expect( defs.parts.first ).to eq( Parts::QuarterOfYear )
    end

    it "matches an outer-scope part from its part symbol" do
      defs = described_class.from_keys( [:year_of_scheme, :month_of_year] )
      expect( defs.parts.first ).to eq( Parts::YearOfScheme )

      defs = described_class.from_keys(
        [:month_of_quarter, :quarter_of_year]
      )
      expect( defs.parts.first ).to eq( Parts::QuarterOfYear )
    end

    it "matches an outer-scope part that is the default for the given unit" do
      defs = described_class.from_keys( [Units::Year, :month] )
      expect( defs.parts.first ).to eq( Parts::YearOfScheme )

      defs = described_class.from_keys(
        [:month, Units::Quarter]
      )
      expect( defs.parts.first ).to eq( Parts::QuarterOfYear )
    end

    it "matches an outer-scope part that is the default for the unit with the given symbol" do
      defs = described_class.from_keys( [:year, :month] )
      expect( defs.parts.first ).to eq( Parts::YearOfScheme )

      defs = described_class.from_keys(
        [:month, :quarter]
      )
      expect( defs.parts.first ).to eq( Parts::QuarterOfYear )
    end

    it "matches sub-component parts from themselves" do
      defs = described_class.from_keys(
        [Parts::YearOfScheme, Parts::MonthOfYear]
      )
      expect( defs.parts.last ).to eq( Parts::MonthOfYear )

      defs = described_class.from_keys(
        [Parts::MonthOfQuarter, Parts::QuarterOfYear, Parts::YearOfScheme]
      )
      expect( defs.parts[1..-1] ).
        to eq( [Parts::QuarterOfYear, Parts::MonthOfQuarter] )
    end

    it "matches sub-component parts from their symbols" do
      defs = described_class.from_keys(
        [:year_of_scheme, :month_of_year]
      )
      expect( defs.parts.last ).to eq( Parts::MonthOfYear )

      defs = described_class.from_keys(
        [:month_of_quarter, :quarter_of_year, :year_of_scheme]
      )
      expect( defs.parts[1..-1] ).
        to eq( [Parts::QuarterOfYear, Parts::MonthOfQuarter] )
    end

    it "matches sub-components by their precision and conaining-scope units" do
      defs = described_class.from_keys( [:year, :month])
      expect( defs.parts.last ).to eq( Parts::MonthOfYear )

      defs = described_class.from_keys(
        [:month, :quarter, :year]
      )
      expect( defs.parts[1..-1] ).
        to eq( [Parts::QuarterOfYear, Parts::MonthOfQuarter] )
    end
  end

end
