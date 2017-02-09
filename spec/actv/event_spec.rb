require 'spec_helper'
require "active_support/time"

describe ACTV::Event do
  before do
    stub_get("/v2/assets/valid_event.json").to_return(body: fixture("valid_event.json"), headers: { content_type: "application/json; charset=utf-8" })
  end

  subject { ACTV.event('valid_event') }

  def format_date date
    date.strftime('%Y-%m-%dT%H:%M:%S')
  end

  def format_date_in_utc date
    format_date(date) << ' UTC'
  end

  describe '#self.valid?' do
    let(:asset_categories) { [] }
    let(:response) { { assetGuid: 1, assetCategories: asset_categories } }
    subject(:valid?) { ACTV::Event.valid? response }
    context 'when the category name is event' do
      let(:asset_categories) { [ { category: { categoryName: "Event", categoryTaxonomy: "" } } ] }
      it { should be_true }
    end
    context 'when the category taxonomy is event' do
      let(:asset_categories) { [ { category: { categoryName: "", categoryTaxonomy: "Races/Event" } } ] }
      it { should be_true }
    end
    context 'when there is no category taxonomy or name' do
      it { should be_false }
    end
  end

  describe '#course_map' do
    let(:map_file) { 'https://commuserui-vip.qa.aw.dev.activenetwork.com/sys/filedownload/0/CourseMap_15260251_1469500165160' }
    let(:response) { {assetGuid: 1, assetTags: [{tag: {tagId: '1801633', tagName: map_file, tagDescription: 'coursemap'}}]} }
    subject(:event) { ACTV::Event.new response }

    context 'when coursemap tag exists' do
      its(:course_map) { should eq map_file }
    end

    context 'when coursemap tag does not exists' do
      let(:response) { {assetGuid: 1} }
      its(:course_map) { should be_nil }
    end
  end

  describe '#online_registration_available?' do
    context "when registrationUrlAdr is present" do
      before { subject.stub(:registrationUrlAdr).and_return("something") }

      context "when legacy_data is present" do
        context "when online_registration field is string value 'true'" do
          before { subject.legacy_data.stub(:onlineRegistration).and_return("true") }
          its(:online_registration_available?) { should be_true }
        end

        context 'when online_registration field is bool value true' do
          before { subject.legacy_data.stub(:onlineRegistration).and_return(true) }
          its(:online_registration_available?) { should be_true }
        end

        context "when online_registration field is string value 'false'" do
          before { subject.legacy_data.stub(:onlineRegistration).and_return("false") }
          its(:online_registration_available?) { should be_false }
        end

        context "when online_registration field is bool value false" do
          before { subject.legacy_data.stub(:onlineRegistration).and_return(false) }
          its(:online_registration_available?) { should be_false }
        end

        context "when online_registration field is blank" do
          before { subject.legacy_data.stub(:onlineRegistration).and_return('') }
          its(:online_registration_available?) { should be_true }
        end

        context "when online_registration field is not present" do
          before { subject.legacy_data.stub(:onlineRegistration).and_return(nil) }
          its(:online_registration_available?) { should be_true }
        end
      end

      context "when legacy_data is not present" do
        before { subject.stub(:legacy_data).and_return(nil) }
        its(:online_registration_available?) { should be_true }
      end
    end

    context "when legacy_data is not present" do
      before { subject.stub(:legacy_data).and_return(nil) }

      context "when legacy_data is present" do
        context "when online_registration field is true" do
          before { subject.legacy_data.stub(:onlineRegistration).and_return(true) }
          its(:online_registration_available?) { should be_false }
        end

        context "when online_registration field is false" do
          before { subject.legacy_data.stub(:onlineRegistration).and_return(false) }
          its(:online_registration_available?) { should be_false }
        end
      end

      context "when legacy_data is not present" do
        before { subject.stub(:legacy_data).and_return(nil) }
        its(:online_registration_available?) { should be_false }
      end
    end
  end

  describe '#registration_open_date' do
    before { subject.stub(:sales_start_date).and_return format_date 1.day.from_now }
    it "returns the correct date in the correct timezone" do
      subject.registration_open_date.should be_within(1.second).of Time.parse format_date_in_utc 1.day.from_now
    end
  end

  describe '#registration_close_date' do
    before { subject.stub(:sales_end_date).and_return format_date 1.day.from_now }
    it "returns the correct date in the correct timezone" do
      subject.registration_close_date.should be_within(1.second).of Time.parse format_date_in_utc 1.day.from_now
    end
  end

  describe '#event_start_date' do
    before do
      subject.stub(:activity_start_date).and_return("2013-05-10T00:00:00")
      subject.stub(:timezone_offset).and_return(-4)
    end
    it "returns the correct date in the correct timezone" do
      subject.event_start_date.should eq Time.parse "2013-05-10T00:00:00 -0400"
    end
  end

  describe '#event_end_date' do
    before do
      subject.stub(:activity_end_date).and_return("2013-05-10T00:00:00")
      subject.stub(:timezone_offset).and_return(-4)
    end
    it "returns the correct date in the correct timezone" do
      subject.event_end_date.should eq Time.parse "2013-05-10T00:00:00 -0400"
    end
  end

  describe '#registration_not_yet_open' do

    context 'when the event has sales start date' do
      context 'when now is before the date' do
        before do
          subject.stub(:sales_start_date).and_return format_date 1.day.from_now
          subject.stub(:registrationUrlAdr).and_return("something")
        end
        its(:registration_not_yet_open?) { should be_true }
      end
      context 'when now is after the date' do
        before do
          subject.stub(:sales_start_date).and_return format_date 1.day.ago
        end
        its(:registration_not_yet_open?) { should be_false }
      end
    end
    context 'when the event does not have a sales start date' do
      before do
        subject.stub(:sales_start_date).and_return nil
      end
      its(:registration_not_yet_open?) { should be_false }

      context 'when the event has no dates' do
        before do
          subject.stub(:sales_start_date).and_return nil
          subject.stub(:sales_end_date).and_return nil
          subject.stub(:activity_start_date).and_return nil
          subject.stub(:activity_end_date).and_return nil
        end
        its(:registration_not_yet_open?) { should be_false }
      end
    end
  end

  describe '#registration_closed' do

    context 'when the event has sales end date' do
      context 'when now is before the date' do
        before do
          subject.stub(:sales_end_date).and_return format_date 1.day.from_now
        end
        its(:registration_closed?) { should be_false }
      end
      context 'when now is after the date' do
        before do
          subject.stub(:sales_end_date).and_return format_date 1.day.ago
          subject.stub(:registrationUrlAdr).and_return("something")
        end
        its(:registration_closed?) { should be_true }
      end
    end
    context 'when the event does not have a sales end date' do
      before do
        subject.stub(:sales_end_date).and_return nil
      end
      context 'when the event has an activity end date' do
        context 'when now is before the date' do
          before do
            subject.stub(:activity_end_date).and_return format_date 1.day.from_now
          end
          its(:registration_closed?) { should be_false }
        end
        context 'when now is after the date' do
          before do
            subject.stub(:activity_end_date).and_return format_date 1.day.ago
            subject.stub(:registrationUrlAdr).and_return("something")
          end
          its(:registration_closed?) { should be_true }
        end
      end
      context 'when the event has no dates' do
        before do
          subject.stub(:sales_start_date).and_return nil
          subject.stub(:sales_end_date).and_return nil
          subject.stub(:activity_start_date).and_return nil
          subject.stub(:activity_end_date).and_return nil
        end
        its(:registration_closed?) { should be_false }
      end
    end
  end

  describe '#registration_open' do
    subject { ACTV.event('valid_event') }

    context 'when the event is unregisterable' do
      before do
        subject.stub(:online_registration_available?).and_return false
      end
      its(:registration_open?) { should be_false }
    end

    context 'when the event has sales start and end dates' do
      context 'when now is between start and end dates' do
        before do
          subject.stub(:sales_start_date).and_return format_date 1.day.ago
          subject.stub(:sales_end_date).and_return format_date 1.day.from_now
          subject.stub(:registrationUrlAdr).and_return("something")
        end
        its(:registration_open?) { should be_true }
      end

      context 'when now is before start' do
        before do
          subject.stub(:sales_start_date).and_return format_date 1.day.from_now
          subject.stub(:sales_end_date).and_return format_date 2.days.from_now
        end
        its(:registration_open?) { should be_false }
      end

      context 'when now is after end' do
        before do
          subject.stub(:sales_start_date).and_return format_date 2.days.ago
          subject.stub(:sales_end_date).and_return format_date 1.day.ago
        end
        its(:registration_open?) { should be_false }
      end
    end

    context 'when the event does not have sales start and end dates' do
      before do
        subject.stub(:sales_start_date).and_return nil
        subject.stub(:sales_end_date).and_return nil
      end
      context 'when the event has activity start and end dates' do
        before do
          subject.stub(:activity_start_date).and_return format_date 2.days.ago
          subject.stub(:activity_end_date).and_return format_date 2.days.from_now
        end
        context 'when now is between start and end dates' do
          before do
            subject.stub(:activity_start_date).and_return format_date 2.days.ago
            subject.stub(:activity_end_date).and_return format_date 2.days.from_now
            subject.stub(:registrationUrlAdr).and_return("something")
          end
          its(:registration_open?) { should be_true }
        end
        context 'when now is after end' do
          before do
            subject.stub(:activity_start_date).and_return format_date 3.days.ago
            subject.stub(:activity_end_date).and_return format_date 2.days.ago
          end
          its(:registration_open?) { should be_false }
        end
      end
      context 'when the event does not have activity start and end dates' do
        before do
          subject.stub(:activity_start_date).and_return nil
          subject.stub(:activity_end_date).and_return nil
          subject.stub(:registrationUrlAdr).and_return("something")
        end
        its(:registration_open?) { should be_true } # Huiwen says this is correct
      end
    end
  end

  describe "Fixes for LH bugs" do
    describe "LH-925" do
      context "when the sales dates are not available" do
        before do
          subject.stub(:sales_start_date).and_return nil
          subject.stub(:sales_end_date).and_return nil
        end
        context "when the activity start and end date are the same" do
          before do
            subject.stub(:activity_start_date).and_return format_date 1.month.ago
            subject.stub(:activity_end_date).and_return format_date Date.today
            subject.stub(:registrationUrlAdr).and_return("something")
          end
          its(:event_ended?) { should be_false }
          its(:registration_open?) { should be_true }
        end
      end
    end

    describe "LH-906" do
      context 'when the sales_start_date is nil, sales_end_date is in the past and today is between activity start and end' do
        before do
          subject.stub(:sales_start_date).and_return nil
          subject.stub(:sales_end_date).and_return format_date 2.days.ago
          subject.stub(:activity_start_date).and_return format_date 1.day.ago
          subject.stub(:activity_end_date).and_return format_date 1.day.from_now
          subject.stub(:registrationUrlAdr).and_return("something")
        end
        its(:registration_not_yet_open?)  { should be_false }
        its(:registration_open?)          { should be_false }
        its(:registration_closed?)        { should be_true }
      end
    end
  end

  describe '#disply_close_date' do
    context 'when tag is not set' do
      before do
        subject.stub(:tag_by_description).with("displayclosedate").and_return nil
      end

      its(:display_close_date?) { should eq true }
    end

    context 'when tag is set' do
      context 'when true' do
        before do
          subject.stub(:tag_by_description).with("displayclosedate").and_return 'true'
        end

        its(:display_close_date?) { should eq true }
      end

      context 'when false' do
        before do
          subject.stub(:tag_by_description).with("displayclosedate").and_return 'false'
        end

        its(:display_close_date?) { should eq false }
      end
    end
  end

  describe '#video' do
    context 'when the event has a video AssetImage' do

      let(:image1) { ACTV::AssetImage.new({
        imageUrlAdr: 'http://test.com/1.jpg',
        imageName: 'image1',
        imageType: 'VIDEO',
        imageCaptionTxt: 'caption1',
        linkUrl: 'http://test.com/',
        linkTarget: 'VIDEO'
        }) }

      before do
        allow(subject).to receive(:images).and_return([image1])
      end

      it 'returns the video AssetImage' do
        subject.video.should eq image1
      end

      context 'when the event has more than one video AssetImage' do

        let(:image2) { ACTV::AssetImage.new({
          imageUrlAdr: 'http://test.com/2.jpg',
          imageName: 'image2',
          imageType: 'VIDEO',
          imageCaptionTxt: 'caption2',
          linkUrl: 'http://test.com/',
          linkTarget: 'VIDEO'
          }) }

        before do
          allow(subject).to receive(:images).and_return([image1, image2])
        end

        it 'returns the first video AssetImage' do
          subject.video.should eq image1
        end
      end
    end

    context 'when the event has no video AssetImage' do
      it 'returns nil' do
        subject.video.should be_nil
      end
    end
  end
end
