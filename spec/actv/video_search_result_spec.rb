require 'spec_helper'

describe ACTV::VideoSearchResults do
  describe '#results' do
    context "when results is set" do
      let(:assets){ [{assetGuid: '4cfb7657-6f5a-4a2a-adf3-c2b6986cb1eb', assetName: 'QA test'}, {assetGuid: 'eeb5a96a-dc6c-4a22-ad42-c0ce18832669', assetName: 'QA test2'}] }
      let(:results){ ACTV::VideoSearchResults.new({results: assets}).results }

      it 'should return an array of ACTV::Video' do
        expect(results).to be_a Array
        expect(results.first).to be_a ACTV::Video
      end
    end

    context "when results is not set" do
      let(:results){ ACTV::VideoSearchResults.new({}).results }
      it "should return an empty array" do
        expect(results).to eq([])
      end
    end
  end
end