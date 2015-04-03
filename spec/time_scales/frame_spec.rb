require 'spec_helper'

describe TimeScales::Frame do
  context "an instance for a specific year" do
    subject { described_class[year: 2014] }

    it "exposes its year through its #year_of_scheme property" do
      expect( subject.year_of_scheme ).to eq( 2014 )
    end

    it "exposes its year through its #year property" do
      expect( subject.year ).to eq( 2014 )
    end

    it "is convertible to the time at the start of the year" do
      pending
      expect( subject.to_time ).to eq( Time.new(2014, 1, 1, 0, 0, 0) )
    end

    it "is convertible to range from year start until (but not including) next year start" do
      pending
      year_start      = Time.new(2014, 1, 1, 0, 0, 0)
      next_year_start = Time.new(2015, 1, 1, 0, 0, 0)
      expect( subject.to_range ).to eq( year_start...next_year_start )
    end
  end
end
