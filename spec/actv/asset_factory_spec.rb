require 'spec_helper'

describe ACTV::AssetFactory do
  let(:category_name) { "" }
  let(:category_taxonomy) { "" }
  let(:legacy_guid) { "777" }
  let(:response) { {assetGuid: "111",
                    sourceSystem: {legacyGuid: legacy_guid},
                    assetCategories: [{category: {categoryName: category_name,
                                                  categoryTaxonomy: category_taxonomy}}]} }
  subject(:asset) { ACTV::AssetFactory.new(response).asset }

  describe '#asset' do
    context 'the response is not an author, event or article' do
      it 'returns an actv asset' do
        expect(asset).to be_a ACTV::Asset
      end
    end
    context 'the response has an article category' do
      let(:category_name) { "Articles" }
      it 'returns an actv article' do
        expect(asset).to be_a ACTV::Article
      end
    end
    context 'the response is from ACM' do
      let(:legacy_guid) { "CA4EA0B1-7377-470D-B20D-BF6BEA23F040" }
      it 'returns an actv article' do
        expect(asset).to be_a ACTV::Article
      end
    end
    context 'the response has an event category' do
      let(:category_name) { "Event" }
      it 'returns an actv event' do
        expect(asset).to be_a ACTV::Event
      end
    end
    context 'the response has an event taxonomy' do
      let(:category_taxonomy) { "Race/Event" }
      it 'returns an actv event' do
        expect(asset).to be_a ACTV::Event
      end
    end
    context 'the response has an author category' do
      let(:category_name) { "Author" }
      it 'returns an actv author' do
        expect(asset).to be_a ACTV::Author
      end
    end
  end
end
