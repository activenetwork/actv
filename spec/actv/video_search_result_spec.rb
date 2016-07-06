require 'spec_helper'

describe ACTV::VideoSearchResults do
  describe '#results' do
    it 'should return an array of ACTV::Video when results is set' do
      results = ACTV::VideoSearchResults.new({results: [{assetGuid: '4cfb7657-6f5a-4a2a-adf3-c2b6986cb1eb', assetName: 'QA test'}, {assetGuid: 'eeb5a96a-dc6c-4a22-ad42-c0ce18832669', assetName: 'QA test2'}]}).results
      results.should be_a Array
      results.first.should be_a ACTV::Video
    end
    
    it 'should return an emtpy array when results is not set' do
      results = ACTV::VideoSearchResults.new({}).results
      results.should eql []
    end
  end
end