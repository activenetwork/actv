require 'spec_helper'

describe ACTV::Article do
  let(:descriptions) { [ { description: "article source", descriptionType: { descriptionTypeId: "1", descriptionTypeName: "articleSource" } },
                         { description: "article subtitle", descriptionType: { descriptionTypeId: "2", descriptionTypeName: "subtitle" } },
                         { description: "by Yason", descriptionType: { descriptionTypeId: "3", descriptionTypeName: "articleByLine" } },
                         { description: "article footer", descriptionType: { descriptionTypeId: "4", descriptionTypeName: "footer" } } ] }
  let(:asset_images) { [] }
  let(:asset_categories) { [] }
  let(:asset_tags) { [] }
  let(:asset_references) { [] }
  let(:response) { { assetGuid: 1,
                     assetDescriptions: descriptions,
                     assetTags: asset_tags,
                     assetImages: asset_images,
                     assetCategories: asset_categories,
                     assetReferences: asset_references } }
  subject(:article) { ACTV::Article.new response }

  describe '#self.valid?' do
    subject(:valid?) { ACTV::Article.valid? response }
    context 'when the category name is articles' do
      let(:asset_categories) { [ { category: { categoryName: "Articles", categoryTaxonomy: "" } } ] }
      it { should be_true }
    end
    context 'when the category taxonomy is articles' do
      let(:asset_categories) { [ { category: { categoryName: "", categoryTaxonomy: "Creative Work/Articles" } } ] }
      it { should be_true }
    end
    context 'when there is no category taxonomy or name' do
      it { should be_false }
    end
  end

  describe '#source' do
    context 'when an articleSource description exists' do
      its(:source) { should eq "article source" }
    end
    context 'when an articleSource description does not exist' do
      let(:descriptions) { [] }
      its(:source) { should be_nil }
    end
  end

  describe '#type' do
    context 'when an articleType tag description exists' do
      let(:asset_tags) { [ { tag: { tagId: '2', tagName: 'mediagallery', tagDescription: 'articleType' } } ] }
      its(:type) { should eq "mediagallery" }
    end
    context 'when an articleType tag description does not exist' do
      its(:type) { should be_nil }
    end
  end

  describe '#media_gallery?' do
    context 'when the articleType tag is mediagallery' do
      let(:asset_tags) { [ { tag: { tagId: '2', tagName: 'mediagallery', tagDescription: 'articleType' } } ] }
      its(:media_gallery?) { should be_true }
    end
    context 'when the articleType tag is not mediagallery' do
      its(:media_gallery?) { should be_false }
    end
  end

  describe '#image' do
    context 'when article has an image named image2' do
      let(:asset_images) { [ { imageName: "image2" } ] }
      it 'returns the image' do
        expect(article.image).to be_a ACTV::AssetImage
      end
    end
    context 'when article does not have an image named image2' do
      it 'returns nil' do
        expect(article.image).to be_nil
      end
    end
  end

  describe '#subtitle' do
    context 'when a subtitle description exists' do
      its(:subtitle) { should eq "article subtitle" }
    end
    context 'when a subtitle description does not exist' do
      let(:descriptions) { [] }
      its(:subtitle) { should be_nil }
    end
  end

  describe '#footer' do
    context 'when a footer description exists' do
      its(:footer) { should eq "article footer" }
    end
    context 'when a footer description does not exist' do
      let(:descriptions) { [] }
      its(:footer) { should be_nil }
    end
  end

  describe '#inline_ad?' do
    context 'if inlindead is set to true' do
      let(:asset_tags) { [ { tag: { tagId: '1', tagName: 'true', tagDescription: 'inlinead' } } ] }
      its(:inline_ad?) { should be_true }
    end
    context 'if inlindead is set to false' do
      let(:asset_tags) { [ { tag: { tagId: '2', tagName: 'false', tagDescription: 'inlinead' } } ] }
      its(:inline_ad?) { should be_false }
    end
    context 'if inlindead is not set' do
      its(:inline_ad?) { should be_true }
    end
  end

  describe '#author' do
    context 'when an author reference exists' do
      let(:asset_references) { [ { referenceAsset: { assetGuid: "123" }, referenceType: { referenceTypeName: "author" } } ] }
      before do
        stub_request(:post, "http://api.amp.active.com/v2/assets.json").
          to_return(body: fixture("valid_author.json"))
      end
      context 'when the author exists in a3pi' do
        its(:author) { should be_a ACTV::Author }
      end
      context 'when the author does not exist in a3pi' do
        before do
          allow(ACTV).to receive(:asset).and_raise ACTV::Error::NotFound
        end
        its(:author) { should be_a ACTV::Author }
      end
    end
    context 'when an author reference does not exist' do
      its(:author) { should be_a ACTV::Author }
    end
  end

  describe '#is_article?' do
    its(:is_article?) { should be_true }
  end

  describe '#author_from_by_line' do
    context 'when a by line is present' do
      context 'when a match is found' do
        its(:author_name_from_by_line) { should eq "Yason" }
      end
      context 'when a match is not found' do
        let(:descriptions) { [] }
        its(:author_name_from_by_line) { should be_nil }
      end
    end
    context 'when a by line is not present' do
      let(:descriptions) { [] }
      its(:author_name_from_by_line) { should be_nil }
    end
  end
end
