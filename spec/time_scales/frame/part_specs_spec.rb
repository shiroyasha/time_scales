require 'spec_helper'

module TimeScales

  describe Frame::PartSpecs do
    it "produces an empty parts sequence for an empty key list" do
      specs = described_class.from_keys( [] )
      expect( specs.parts ).to eq( [] )
    end

    it "matches an outer-scope part from itself" do
      specs = described_class.from_keys( [Parts::YearOfScheme] )
      expect( specs.parts.first ).to eq( Parts::YearOfScheme )

      specs = described_class.from_keys(
        [Parts::MonthOfQuarter, Parts::QuarterOfYear]
      )
      expect( specs.parts.first ).to eq( Parts::QuarterOfYear )
    end

    it "matches an outer-scope part from its part symbol" do
      specs = described_class.from_keys( [:year_of_scheme, :month_of_year] )
      expect( specs.parts.first ).to eq( Parts::YearOfScheme )

      specs = described_class.from_keys(
        [:month_of_quarter, :quarter_of_year]
      )
      expect( specs.parts.first ).to eq( Parts::QuarterOfYear )
    end

    it "matches an outer-scope part that is the default for the given unit" do
      specs = described_class.from_keys( [Units::Year, :month] )
      expect( specs.parts.first ).to eq( Parts::YearOfScheme )

      specs = described_class.from_keys(
        [:month, Units::Quarter]
      )
      expect( specs.parts.first ).to eq( Parts::QuarterOfYear )
    end

    it "matches an outer-scope part that is the default for the unit with the given symbol" do
      specs = described_class.from_keys( [:year, :month] )
      expect( specs.parts.first ).to eq( Parts::YearOfScheme )

      specs = described_class.from_keys(
        [:month, :quarter]
      )
      expect( specs.parts.first ).to eq( Parts::QuarterOfYear )
    end

    it "matches sub-component parts from themselves" do
      specs = described_class.from_keys(
        [Parts::YearOfScheme, Parts::MonthOfYear]
      )
      expect( specs.parts.last ).to eq( Parts::MonthOfYear )

      specs = described_class.from_keys(
        [Parts::MonthOfQuarter, Parts::QuarterOfYear, Parts::YearOfScheme]
      )
      expect( specs.parts[1..-1] ).
        to eq( [Parts::QuarterOfYear, Parts::MonthOfQuarter] )
    end

    it "matches sub-component parts from their symbols" do
      specs = described_class.from_keys(
        [:year_of_scheme, :month_of_year]
      )
      expect( specs.parts.last ).to eq( Parts::MonthOfYear )

      specs = described_class.from_keys(
        [:month_of_quarter, :quarter_of_year, :year_of_scheme]
      )
      expect( specs.parts[1..-1] ).
        to eq( [Parts::QuarterOfYear, Parts::MonthOfQuarter] )
    end

    it "matches sub-components by their precision and conaining-scope units" do
      specs = described_class.from_keys( [:year, :month])
      expect( specs.parts.last ).to eq( Parts::MonthOfYear )

      specs = described_class.from_keys(
        [:month, :quarter, :year]
      )
      expect( specs.parts[1..-1] ).
        to eq( [Parts::QuarterOfYear, Parts::MonthOfQuarter] )
    end
  end

end
