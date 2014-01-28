require 'spec_helper'

describe ACTV::Identity do
  describe "#initialize" do
    it "raises an ArgumentError when type is not specified" do
      lambda {
        ACTV::Identity.new
      }.should raise_error ArgumentError
    end
  end

  describe "#==" do
    it "returns true when objects IDs are the same" do
      one = ACTV::Identity.new(:id => 1, :screen_name => "sferik")
      two = ACTV::Identity.new(:id => 1, :screen_name => "garybernhardt")
      (one == two).should be_true
    end

    it "returns false when objects IDs are different" do
      one = ACTV::Identity.new(:id => 1)
      two = ACTV::Identity.new(:id => 2)
      (one == two).should be_false
    end

    it "returns false when classes are different" do
      one = ACTV::Identity.new(:id => 1)
      two = ACTV::Base.new(:id => 1)
      (one == two).should be_false
    end
  end
end