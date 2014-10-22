require 'spec_helper'

describe ACTV::AssetTopic do

  let(:topic) { ACTV::AssetTopic.new sequence: '1' }
  let(:topic_2) { ACTV::AssetTopic.new sequence: '2' }
  
  describe "attribute accessors and aliases" do
    subject { topic }

    its(:sequence){ should eq '1' }
    it "sorts by sequence" do
      [topic_2,topic].sort.first.sequence.should eq '1'
    end

  end

end