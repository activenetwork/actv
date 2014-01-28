require 'spec_helper'

describe ACTV::Base do

  before do
    @base = ACTV::Base.new(:id => 1)
  end

  describe "#[]" do
    it "calls methods using [] with symbol" do
      @base[:object_id].should be_an Integer
    end
    it "calls methods using [] with string" do
      @base['object_id'].should be_an Integer
    end
    it "returns nil for missing method" do
      @base[:foo].should be_nil
      @base['foo'].should be_nil
    end
  end

  describe "#attrs" do
    it "returns a hash of attributes" do
      @base.attrs.should eq({:id => 1})
    end
  end

  describe "#delete" do
    it "deletes an attribute and returns its value" do
      base = ACTV::Base.new(:id => 1)
      base.delete(:id).should eq(1)
      base.attrs[:id].should be_nil
    end
  end

  describe "#update" do
    it "returns a hash of attributes" do
      base = ACTV::Base.new(:id => 1)
      base.update(:id => 2)
      base.attrs[:id].should eq(2)
    end
  end

  describe "#to_hash" do
    it "returns a hash" do
      @base.to_hash.should be_a Hash
      @base.to_hash[:id].should eq 1
    end
  end

end