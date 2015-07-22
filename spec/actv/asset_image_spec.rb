require 'spec_helper'

describe ACTV::AssetImage do
  let(:imageType) { 'IMAGE' }
  let(:linkTarget) { '_blank' }
  subject(:img) { ACTV::AssetImage.new({
    imageUrlAdr: 'http://test.com/1.jpg',
    imageName: 'image1',
    imageType: imageType,
    imageCaptionTxt: 'caption1',
    linkUrl: 'http://test.com/',
    linkTarget: linkTarget
    }) }

  describe "attribute accessors and aliases" do
    its(:url){ should eq 'http://test.com/1.jpg' }
    its(:name){ should eq 'image1' }
    its(:type){ should eq 'IMAGE' }
    its(:caption){ should eq 'caption1' }
    its(:link){ should eq 'http://test.com/'}
    its(:target){ should eq '_blank' }
    its(:imageUrlAdr){ should eq 'http://test.com/1.jpg' }
    its(:imageName){ should eq 'image1' }
    its(:imageType){ should eq 'IMAGE' }
    its(:imageCaptionTxt){ should eq 'caption1' }
    its(:linkUrl){ should eq 'http://test.com/'}
    its(:linkTarget){ should eq '_blank' }
  end

  describe "#video?" do
    context "when neither imageType nor linkTarget are video" do
      it "knows it's not a video AssetImage" do
        expect(subject.video?).to be_false
      end
    end

    context "when imageType is video" do
      let(:imageType) { 'VIDEO' }
      it "knows it's a video AssetImage" do
        expect(subject.video?).to be_true
      end
    end

    context "when linkTarget is video" do
      let(:linkTarget) { 'VIDEO' }
      it "knows it's a video AssetImage" do
        expect(subject.video?).to be_true
      end
    end
  end

end
