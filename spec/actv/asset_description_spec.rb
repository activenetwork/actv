require 'spec_helper'

describe ACTV::AssetDescription do

  describe "#description_type" do
    it "returns a Asset Description Type when descriptionType is set" do
      description_type = ACTV::AssetDescription.new(description: "Description #1", descriptionType: { descriptionTypeId: 1, descriptionTypeName: "TYPE" }).description_type
      description_type.should be_a ACTV::AssetDescriptionType
    end

    it "returns nil when descriptionType is not set" do
      description_type = ACTV::AssetDescription.new(description: "Description #1").description_type
      description_type.should be_nil
    end
  end

end