require 'spec_helper'

describe ACTV::AssetFactory do
  let(:category_name) { "" }
  let(:category_taxonomy) { "" }
  let(:response) { {assetGuid: "111",
                    assetCategories: [{category: {categoryName: category_name,
                                                  categoryTaxonomy: category_taxonomy}}]} }
  subject(:asset) { ACTV::AssetFactory.new(response).asset }

  describe '#asset' do
    context 'the response is not an author, event or article' do
      it { should be_a ACTV::Asset }
    end
    context 'the response has an article category' do
      let(:category_name) { "Articles" }
      it { should be_a ACTV::Article }
    end
    context 'the response has an article taxonomy' do
      let(:category_taxonomy) { "Running/Articles" }
      it { should be_a ACTV::Article }
    end
    context 'the response has an event category' do
      let(:category_name) { "Event" }
      it { should be_a ACTV::Event }
    end
    context 'the response has an event taxonomy' do
      let(:category_taxonomy) { "Race/Event" }
      it { should be_a ACTV::Event }
    end
    context 'the response has an author category' do
      let(:category_name) { "Author" }
      it { should be_a ACTV::Author }
    end
    context 'the response has an author taxonomy' do
      let(:category_taxonomy) { "Running/Author" }
      it { should be_a ACTV::Author }
    end
  end
end
