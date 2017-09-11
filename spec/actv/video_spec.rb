require 'spec_helper'

describe ACTV::Video do
  let(:asset_images) { [{:imageUrlAdr => "http://RODALE.images.worldnow.com/images/12508455_vtf.jpg", :imageName => "videoImage"}] }
  let(:urlAdr) { "http://rodale.videodownload.worldnow.com/RODALE_0906201614333627818AA.mp4" }
  let(:asset_tags) { [{:tag => {:tagId => "1794337", :tagName => "video/mp4", :tagDescription => "type"}},
                      {:tag => {:tagId => "1794525", :tagName => "640", :tagDescription => "width"}},
                      {:tag => {:tagId => "1794598", :tagName => "997", :tagDescription => "bitrate"}},
                      {:tag => {:tagId => "1794597", :tagName => "training,fitness,health & injuries", :tagDescription => "keywords"}},
                      {:tag => {:tagId => "1794599", :tagName => "140", :tagDescription => "duration"}},
                      {:tag => {:tagId => "1794526", :tagName => "360", :tagDescription => "height"}},
                      {:tag => {:tagId => "1794600", :tagName => "18370674", :tagDescription => "filesize"}},
                      {:tag => {:tagId => "1795103", :tagName => "http://rodale.worldnow.com/clip/12508455/these-foam-rolling-moves-can-help-you-recover-faster", :tagDescription => "canonicalUrl"}}] }
  let(:asset_categories) { [{:sequence => "1", :category => {:categoryId => "8", :categoryTaxonomy => "Creative Work/Videos", :categoryName => "Videos"}}] }

  let(:response) { {assetGuid: 1,
                    urlAdr: urlAdr,
                    assetTags: asset_tags,
                    assetImages: asset_images,
                    assetCategories: asset_categories} }
  let(:video) { ACTV::Video.new response }

  describe "#self.valid?" do
    let(:valid) { ACTV::Video.valid? response }

    context "when the category name is videos" do
      let(:asset_categories) { [{category: {categoryName: "Videos", categoryTaxonomy: ""}}] }

      it "should return true" do
        expect(valid).to be true
      end
    end

    context "when the category name is articles" do

      let(:asset_categories) { [{category: {categoryName: "Articles", categoryTaxonomy: ""}}] }
      it "should return false" do
        expect(valid).to be false
      end
    end
  end

  describe "#source" do
    context "when a video source is exists" do
      it "should return video play source" do
        expect(video.source).to eq(urlAdr)
      end
    end
  end

  describe "#keywords" do
    context "when a video tag with tagDescription equal keywords exists" do
      it "should return keywords" do
        expect(video.keywords).to eq("training,fitness,health & injuries")
      end
    end
  end

  describe "#type" do
    context "when a video tag with tagDescription equal type exists" do
      it "should return video type as 'video/mp4'" do
        expect(video.type).to eq("video/mp4")
      end
    end
  end

  describe "#width" do
    context "when a video tag with tagDescription equal width exists" do
      it "should return video width" do
        expect(video.width).to eq("640")
      end
    end
  end

  describe "#height" do
    context "when a video tag with tagDescription equal height exists" do
      it "should return video height" do
        expect(video.height).to eq("360")
      end
    end
  end

  describe "#bitrate" do
    context "when a video tag with tagDescription equal bitrate exists" do
      it "should return bitrate" do
        expect(video.bitrate).to eq("997")
      end
    end
  end

  describe "#duration" do
    context 'when a video tag with tagDescription equal duration exists' do
      it "should return duration" do
        expect(video.duration).to eq("140")
      end
    end
  end

  describe "#filesize" do
    context "when a video tag with tagDescription equal filesize exists" do
      it "should return filesize" do
        expect(video.filesize).to eq("18370674")
      end
    end
  end

  describe "#canonical_url" do
    context "when a video tag with tagDescription equal canonical_url exists" do
      it "should return canonical url" do
        expect(video.canonical_url).to eq("http://rodale.worldnow.com/clip/12508455/these-foam-rolling-moves-can-help-you-recover-faster")
      end
    end
  end

  describe "#cover" do
    context "when a video image exists" do
      it "should return video cover" do
        expect(video.cover).to eq("https://rodale.images.worldnow.com/images/12508455_vtf.jpg")
      end
    end
  end

  describe '#source' do
    it 'starts with https' do
      expect(video.source).to eq("https://rodale.videodownload.worldnow.com/RODALE_0906201614333627818AA.mp4")
    end
  end
end