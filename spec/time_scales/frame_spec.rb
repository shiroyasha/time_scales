require 'spec_helper'

describe TimeScales::Frame do
  context "an instance for a specific year" do
    subject { described_class[year: 2014] }

    it "exposes its year through its #year_of_scheme property" do
      pending
      expect( subject.year_of_scheme ).to eq( 2014 )
    end

    it "exposes its year through its #year property" do
      pending
      expect( subject.year ).to eq( 2014 )
    end
  end
end
