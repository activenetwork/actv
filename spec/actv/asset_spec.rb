require 'spec_helper'
require 'pry'

describe ACTV::Asset do

  describe '#references' do
    let(:asset_references) { [] }
    let(:response) { { assetGuid: 1, assetReferences: asset_references } }
    let(:asset) { ACTV::Asset.new response }
    context 'when there are asset references' do
      let(:asset_references) { [ { referenceAsset: { assetGuid: "123" },
                                   referenceType: { referenceTypeName: "author" } } ] }
      it 'returns an array of asset reference objects' do
        expect(asset.references.first).to be_a ACTV::AssetReference
      end
    end
    context 'when there are no asset references' do
      it 'returns an empty array' do
        expect(asset.references).to be_empty
      end
    end
    context 'when there is no asset references field' do
      let(:response) { { assetGuid: 1 } }
      it 'returns an empty array' do
        expect(asset.references).to be_empty
      end
    end
  end

  describe '#endurance_id' do
    let(:endurance_id) { 'enduranceid' }
    subject(:asset) { ACTV::Asset.new assetGuid: 'assetguid' }

    context 'when asset is awe' do
      before do
        allow(asset).to receive(:registrationUrlAdr).and_return "https://endurancecui-vip.qa.aw.dev.activenetwork.com/event-reg/select-race?e=#{endurance_id}"
        allow(asset).to receive(:awendurance?).and_return true
      end
      it 'returns the endurance id' do
        expect(asset.endurance_id).to eq endurance_id
      end
    end
    context 'when asset is not awe' do
      before { allow(asset).to receive(:awendurance?).and_return false }
      it 'is nil' do
        expect(asset.endurance_id).to be_nil
      end
    end
  end

  describe "#==" do
    it "return true when objects IDs are the same" do
      asset = ACTV::Asset.new(assetGuid: 1, assetName: "Title 1")
      other = ACTV::Asset.new(assetGuid: 1, assetName: "Title 2")
      (asset == other).should be_true
    end

    it "return false when objects IDs are different" do
      asset = ACTV::Asset.new(assetGuid: 1)
      other = ACTV::Asset.new(assetGuid: 2)
      (asset == other).should be_false
    end

    it "return false when classes are different" do
      asset = ACTV::Asset.new(assetGuid: 1)
      other = ACTV::Identity.new(id: 1)
      (asset == other).should be_false
    end
  end

  describe "#place" do
    it "returns a Place when place is set" do
      place = ACTV::Asset.new(assetGuid: 1, assetName: "Asset #1", place: { placeGuid: 1, placeName: "Name #1" }).place
      place.should be_a ACTV::Place
    end

    it "return nil when place is not set" do
      place = ACTV::Asset.new(assetGuid: 1, assetName: "Asset #1").place
      place.should be_nil
    end
  end

  describe "#descriptions" do
    it "returns an Array of Asset Descriptions when assetDescriptions is set" do
      descriptions = ACTV::Asset.new(assetGuid: 1, assetName: "Asset #1", assetDescriptions: [{ description: "Description #1" }, { description: "Description #2" }]).descriptions
      descriptions.should be_a Array
      descriptions.first.should be_a ACTV::AssetDescription
    end

    it "returns an empty array when assetDescriptions is not set" do
      descriptions = ACTV::Asset.new(assetGuid: 1, assetName: "Asset #1").descriptions
      descriptions.should be_a Array
      descriptions.should eq []
    end
  end

  describe "#status" do
    it "returns a Asset Status when assetStatus is set" do
      status = ACTV::Asset.new(assetGuid: 1, assetName: "Asset #1", assetStatus: { assetStatusId: 1, assetStatusName: "Status #1", isSearchable: true }).status
      status.should be_a ACTV::AssetStatus
    end

    it "returns nil when assetStatus is not set" do
      status = ACTV::Asset.new(assetGuid: 1, assetName: "Asset #1").status
      status.should be_nil
    end
  end

  describe "#recurrences" do
    context 'when recurrences are set' do
      let (:recurrences) { ACTV::Asset.new(assetGuid: 1, assetName: "Asset #1",
                                           activityRecurrences: [ {activityStartDate: '2014-09-16T08:30:00', activityEndDate: '2014-11-16T15:30:00',
                                                                   days: 'Mon, Wed, Fri' } ]).recurrences }

      it "returns a Recurrences" do
        recurrences[0].should be_a ACTV::Recurrence
      end
    end


    context 'when recurrences are not set' do
      let (:recurrences) {recurrences = ACTV::Asset.new(assetGuid: 1, assetName: "Asset #1").recurrences }

      it "returns nil " do
        recurrences[0].should be_nil
      end
    end
  end

  describe "#legacy_data" do
    it "returns a Asset Legacy Data when assetLegacyData is set" do
      legacy_data = ACTV::Asset.new(assetGuid: 1, assetName: "Asset #1", assetLegacyData: { assetTypeId: 1, typeName: "Legacy Data", isSearchable: true }).legacy_data
      legacy_data.should be_a ACTV::AssetLegacyData
    end

    it "returns nil when assetLegacyData is not set" do
      legacy_data = ACTV::Asset.new(assetGuid: 1, assetName: "Asset #1").legacy_data
      legacy_data.should be_nil
    end
  end

  describe "#images" do
    it "returns an Array of Asset Images when assetImages is set" do
      images = ACTV::Asset.new(assetGuid: 1, assetName: "Asset #1", assetImages: [{ imageUrlAdr: "img1.jpg" }, { imageUrlAdr: "img2.jpg" }]).images
      images.should be_a Array
      images.first.should be_a ACTV::AssetImage
    end

    it "returns an empty array when assetImages is not set" do
      images = ACTV::Asset.new(assetGuid: 1, assetName: "Asset #1").images
      images.should be_a Array
      images.should eq []
    end
  end

  describe "#tags" do
    it "returns an Array of Asset Tags when assetTags is set" do
      tags = ACTV::Asset.new(assetGuid: 1, assetName: "Asset #1", assetTags: [{ tag: { tagId: 1, tagName: "Tag" } }]).tags
      tags.should be_a Array
      tags.first.should be_a ACTV::AssetTag
    end

    it "returns an empty array when assetImages is not set" do
      tags = ACTV::Asset.new(assetGuid: 1, assetName: "Asset #1").tags
      tags.should be_a Array
      tags.should eq []
    end
  end

  describe "#components" do
    it "returns an Array of Asset Components when assetComponents is set" do
      components = ACTV::Asset.new(assetGuid: 1, assetName: "Asset #1", assetComponents: [{ assetGuid: 1}]).components
      components.should be_a Array
      components.first.should be_a ACTV::AssetComponent
    end

    it "returns an empty array when assetComponents is not set" do
      components = ACTV::Asset.new(assetGuid: 1, assetName: "Asset #1").tags
      components.should be_a Array
      components.should eq []
    end
  end

  describe "#prices" do
    it "returns an Array of Asset Prices when assetPrices is set" do
      prices = ACTV::Asset.new(assetGuid: 1, assetName: "Asset #1", assetPrices: [{ effectiveDate: "2012-08-03T06:59:00", priceAmt: "10" }]).prices
      prices.should be_a Array
      prices.first.should be_a ACTV::AssetPrice
    end

    it "returns an empty array when assetComponents is not set" do
      prices = ACTV::Asset.new(assetGuid: 1, assetName: "Asset #1").tags
      prices.should be_a Array
      prices.should eq []
    end
  end

  describe "#topics" do
    it "returns an Array of Asset Topics when assetTopics is set" do
      topics = ACTV::Asset.new(assetGuid: 1, assetName: "Asset #1", assetTopics: [{ sequence: "1", topic: { topicId: "27", topicName: "Running" } }]).topics
      topics.should be_a Array
      topics.first.should be_a ACTV::AssetTopic
    end

    it "returns an empty array when assetComponents is not set" do
      topics = ACTV::Asset.new(assetGuid: 1, assetName: "Asset #1").topics
      topics.should be_a Array
      topics.should eq []
    end

    it "returns an Array of Assets that are sorted by sequence" do
      topics = ACTV::Asset.new(assetGuid: 1, assetName: "Asset #1", assetTopics: [{ sequence: "2", topic: { topicId: "28", topicName: "Triathlon" } }, { sequence: "1", topic: { topicId: "27", topicName: "Running" } }]).topics
      topics.first.sequence.should eq "1"
    end
  end

  describe "is_event?" do
    before(:each) do
        stub_post("/v2/assets.json").with(:body => {"id"=>"valid_event"}).
          to_return(body: fixture("valid_event.json"))
    end

    it "should return true if the asset has Events as an assetCategory" do
      asset = ACTV.asset('valid_event').first
      asset.is_event?.should be_true
    end

    it "should return true if the asset has no assetCategories but the sourceSystem is Active.com Articles" do
      asset = ACTV.asset('valid_event').first
      asset.stub(:assetCategories).and_return([])
      asset.is_event?.should be_true
    end

    it "should return false if no assetCategory of Event" do
      stub_post("/v2/assets.json").with(:body => {"id"=>"valid_article"}).
        to_return(body: fixture("valid_article.json"))

      asset = ACTV.asset('valid_article').first
      asset.is_event?.should be_false
    end
  end

  describe "is_article?" do
    before(:each) do
        stub_post("/v2/assets.json").with(:body => {"id"=>"valid_article"}).
          to_return(body: fixture("valid_article.json"), headers: { content_type: "application/json; charset=utf-8" })
    end

    it "should return true if the asset has Articles as an assetCategory" do
      asset = ACTV.asset('valid_article')[0]
      asset.is_article?.should be_true
    end

    it "should return true if the asset has no assetCategories but the sourceSystem is Active.com Articles" do
      asset = ACTV.asset('valid_article')[0]
      asset.stub(:assetCategories).and_return([])
      asset.is_article?.should be_true
    end

    it "should return false if no assetCategory of Article" do
      stub_post("/v2/assets.json").with(:body => {"id"=>"valid_event"}).
        to_return(body: fixture("valid_event.json"), headers: { content_type: "application/json; charset=utf-8" })

      asset = ACTV.asset('valid_event')[0]
      asset.is_article?.should be_false
    end
  end

  describe "#attribute_paths" do
    it "returns the attribute values ordered by type" do
      attributes = [ { attribute: { attributeType: 'thing b', attributeValue: 'Bbb' } },
                     { attribute: { attributeType: 'thing a', attributeValue: 'Aaa' } } ]
      asset = ACTV::Asset.new assetGuid: 1, assetAttributes: attributes
      asset.stub sub_topic: "Topic"
      asset.attribute_paths.should == [ 'topic/aaa', 'topic/bbb' ]
    end
  end

  describe "#kids?" do
    let(:asset) { ACTV::Asset.new assetGuid: 1 }

    before do
      class Rails
        def self.env
          "development"
        end
      end
    end

    context "when kids_friendly_source_system? is true" do
      context "by stubbing kids_friendly_source_system?" do
        before { asset.stub kids_friendly_source_system?: true }

        context 'when kids_interest? is true' do
          before { asset.stub kids_interest?: true }

          it 'evaluates to true' do
            asset.kids?.should eq true
          end
        end

        context 'when kids_interest? is false' do
          before { asset.stub kids_interest?: false }

          it 'evaluates to false' do
            asset.kids?.should eq false
          end
        end
      end

      context "and activenet? returns true" do
        let(:asset) { ACTV::Asset.new assetGuid: 1, sourceSystem: {legacyGuid: "FB27C928-54DB-4ECD-B42F-482FC3C8681F"} }

        context 'and kids_interest? is true' do
          before { asset.stub kids_interest?: true }

          it 'evaluates to true' do
            asset.kids?.should eq true
          end
        end
      end

      context "and awcamps30? returns true" do
        let(:asset) { ACTV::Asset.new assetGuid: 1, sourceSystem: {legacyGuid: "89208DBA-F535-4950-880A-34A6888A184C"} }

        context 'and kids_interest? is true' do
          before { asset.stub kids_interest?: true }

          it 'evaluates to true' do
            asset.kids?.should eq true
          end
        end
      end

      context "and acm? returns true" do
        let(:asset) { ACTV::Asset.new assetGuid: 1, sourceSystem: {legacyGuid: "CA4EA0B1-7377-470D-B20D-BF6BEA23F040"} }

        context 'and kids_interest? is true' do
          before { asset.stub kids_interest?: true }

          it 'evaluates to true' do
            asset.kids?.should eq true
          end
        end
      end
    end

    context "when kids_friendly_source_system? is false" do
      context "by stubbing kids_friendly_source_system?" do
        before { asset.stub kids_friendly_source_system?: false }

        it 'evaluates to false' do
          asset.kids?.should eq false
        end
      end

      context "and all source systems return false" do
        before do
          asset.stub activenet?: false
          asset.stub awcamps?: false
          asset.stub awcamps30?: false
          asset.stub acm?: false
        end

        it 'evaluates to false' do
          asset.kids?.should eq false
        end
      end
    end
  end

  describe "#meta_interest_paths" do
    it "returns the meta interest names ordered by sequence" do
      meta_interests = [ { sequence: '2', metaInterest: { metaInterestName: 'Sq2' } },
                         { sequence: '1', metaInterest: { metaInterestName: 'Sq1' } } ]
      asset = ACTV::Asset.new assetGuid: 1, assetMetaInterests: meta_interests
      asset.stub sub_topic: "Topic"
      asset.meta_interest_paths.should == [ 'topic/sq1', 'topic/sq2' ]
    end
  end

  describe "#location_path" do
    it "returns the formatted location" do
      asset = ACTV::Asset.new assetGuid: 1, place: { cityName: "My City", stateProvinceCode: "AA" }
      asset.location_path.should == 'my-city-aa'
    end
  end

  describe "topic path methods" do
    let(:assetTopics) do
      [ { sequence: '2', topic: { topicTaxonomy: "Forth/Fifth/Sixth", topicName: "Triathlon" } },
        { sequence: '1', topic: { topicTaxonomy: "First/Second/Third", topicName: "Running" } } ]
    end
    let(:asset) { ACTV::Asset.new assetGuid: 1, assetTopics: assetTopics }


    describe '#first_topic_name' do
      context 'when asset has topics' do
        it "returns the first topics name" do
          asset.first_topic_name.should == "Running"
        end
      end

      context 'when asset has empty topics' do
        let(:assetTopics) {[]}
        it 'returns nil' do
          expect(asset.first_topic_name).to be_nil
        end
      end
    end

    describe "#first_topic_path" do
      it "returns the first part of the first asset topic" do
        asset.first_topic_path.should == 'first'
      end
    end

    describe "#sub_topic_path" do
      it "returns the second part of the first asset topic" do
        asset.sub_topic_path.should == 'second'
      end
    end

    describe "#sub_2_topic_path" do
      it "returns the third part of the first asset topic" do
        asset.sub_2_topic_path.should == 'second/third'
      end
    end

    context "when there is no sub_2_topic" do
      let(:assetTopics) { [ { sequence: '1', topic: { topicTaxonomy: "first/second" } } ] }
      describe "#sub_2_topic_path" do
        it "has a blank sub 2 topic" do
          asset.sub_2_topic_path.should == "second/"
        end
      end
    end
  end

  describe 'recommended events' do
    let(:asset) { ACTV::Asset.new(assetGuid: 1, assetName: "Asset #1", assetImages: [{ imageUrlAdr: "img1.jpg" }, { imageUrlAdr: "img2.jpg" }]) }
    let(:empty_asset) { ACTV::Asset.new assetGuid: 1 }

    describe "#image_with_placeholder" do
      context "when image_path is empty" do
        it "returns the placeholder image path" do
          asset.stub image_path: ""
          asset.image_with_placeholder.should == "/images/logo-active-icon-gray.gif"
        end
      end

      context "when image_path is not empty" do
        it "returns the image_path" do
          asset.image_with_placeholder.should == "img1.jpg"
        end
      end
    end

    describe "#image_path" do
      context "when image_without_placeholder is nil" do
        it "returns an empty string" do
          asset.stub(:logoUrlAdr) { "" }
          asset.stub(:image_without_placeholder) { nil }
          asset.image_path.should == ""
        end
      end

      context "when image_without_placeholder is an empty string" do
        it "returns an empty string" do
          asset.stub(:logoUrlAdr) { "" }
          asset.stub(:image_without_placeholder) { "" }
          asset.image_path.should == ""
        end
      end

      context "when there is a imageUrlAdr" do
        it "returns the imageUrlAdr" do
          asset.image_path.should == "img1.jpg"
        end
      end

      context "when there is no imageUrlAdr" do
        context "when there is a logoUrlAdr" do
          it "returns the logoUrlAdr" do
            empty_asset.stub(:logoUrlAdr) { "http://example.com/logo.jpg" }
            empty_asset.image_path.should == "http://example.com/logo.jpg"
          end
        end

        context "when there is no logoUrlAdr" do
          it "returns an empty string" do
            empty_asset.stub(:logoUrlAdr) { "" }
            empty_asset.image_path.should == ""
          end
        end
      end
    end

    describe "#media_url" do
      context "when image_without_placeholder is present" do
        context "when imageUrlAdr is present" do
          it "returns the value of imageUrlAdr" do
            asset.media_url.should == "img1.jpg"
          end
        end

        context "when imageUrlAdr is not present" do
          it "returns an empty string" do
           empty_asset.media_url.should == ""
          end
        end

       end

      context "when image_without_placeholder is nil" do
        it "returns an empty string" do
          asset.stub(:image_without_placeholder) { nil }
          asset.media_url.should == ""
        end
      end
    end

    describe "#image" do
      context "the asset has images" do
        it "returns an AssetImage object" do
          asset.image.should be_a ACTV::AssetImage
        end
      end

      context "the asset does not have images" do
        it "returns nil" do
          empty_asset.image.should be_nil
        end
      end
    end
  end

end
