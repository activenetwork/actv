require 'spec_helper'

describe ACTV::NullObject do
  describe "#nil?" do
    it "returns true" do
      null_object = ACTV::NullObject.instance
      null_object.null?.should be_true
    end
  end

  describe "calling any method" do
    it "returns self" do
      null_object = ACTV::NullObject.instance
      null_object.any.should equal null_object
    end
  end

  describe "#respond_to?" do
    it "returns true" do
      null_object = ACTV::NullObject.instance
      null_object.respond_to?(:any).should be_true
    end
  end
end