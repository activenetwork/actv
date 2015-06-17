require 'spec_helper'

describe ACTV::Article do
  let(:descriptions) { [] }
  let(:asset_tags) { [] }
  let(:asset_images) { [] }
  let(:asset_references) { [] }
  let(:response) { { assetGuid: 1,
                     assetDescriptions: descriptions,
                     assetTags: asset_tags,
                     assetImages: asset_images,
                     assetReferences: asset_references } }
  subject(:article) { ACTV::Article.new response }

  describe '#source' do
    context 'when an articleSource description exists' do
      let(:descriptions) { [ { description: "article source",
                               descriptionType: { descriptionTypeId: "1",
                                                  descriptionTypeName: "articleSource" } } ] }
      it 'returns the articleSource description' do
        expect(article.source).to eq "article source"
      end
    end
    context 'when an articleSource description does not exist' do
      it 'returns nil' do
        expect(article.source).to be_nil
      end
    end
  end

  describe '#type' do
    context 'when an articleType tag description exists' do
      let(:asset_tags) { [ { tag: { tagId: '1',
                                    tagName: 'article type',
                                    tagDescription: 'articleType' } } ] }
      it 'returns the articleType tag description name' do
        expect(article.type).to eq "article type"
      end
    end
    context 'when an articleType tag description does not exist' do
      it 'returns nil' do
        expect(article.type).to be_nil
      end
    end
  end

  describe '#media_gallery?' do
    context 'when the articleType tag is mediagallery' do
      let(:asset_tags) { [ { tag: { tagId: '1',
                                    tagName: 'mediagallery',
                                    tagDescription: 'articleType' } } ] }
      it 'returns true' do
        expect(article.media_gallery?).to be_true
      end
    end
    context 'when the articleType tag is not mediagallery' do
      it 'returns false' do
        expect(article.media_gallery?).to be_false
      end
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
      let(:descriptions) { [ { description: "article subtitle",
                               descriptionType: { descriptionTypeId: "1",
                                                  descriptionTypeName: "subtitle" } } ] }
      it 'returns the subtitle description' do
        expect(article.subtitle).to eq "article subtitle"
      end
    end
    context 'when a subtitle description does not exist' do
      it 'returns nil' do
        expect(article.subtitle).to be_nil
      end
    end
  end

  describe '#footer' do
    context 'when a footer description exists' do
      let(:descriptions) { [ { description: "article footer",
                               descriptionType: { descriptionTypeId: "1",
                                                  descriptionTypeName: "footer" } } ] }
      it 'returns the footer description' do
        expect(article.footer).to eq "article footer"
      end
    end
    context 'when a footer description does not exist' do
      it 'returns nil' do
        expect(article.footer).to be_nil
      end
    end
  end

  describe '#inline_ad?' do
    context 'if inlindead is set to true' do
      let(:asset_tags) { [ { tag: { tagId: '1',
                                    tagName: 'true',
                                    tagDescription: 'inlinead' } } ] }
      it 'should return true' do
        article.inline_ad?.should eq true
      end
    end
    context 'if inlindead is set to false' do
      let(:asset_tags) { [ { tag: { tagId: '1',
                                    tagName: 'false',
                                    tagDescription: 'inlinead' } } ] }
      it 'should return false' do
        article.inline_ad?.should eq false
      end
    end
    context 'if inlindead is not set' do
      it 'should return true' do
        article.inline_ad?.should eq true
      end
    end
  end

  describe '#author' do
    context 'when an author reference exists' do
      before do
        stub_request(:post, "http://api.amp.active.com/v2/assets.json").
          to_return(body: fixture("valid_author.json"))
      end
      let(:asset_references) { [ { referenceAsset: { assetGuid: "123" },
                                   referenceType: { referenceTypeName: "author" } } ] }
      context 'when the author exists in a3pi' do
        it 'returns an author asset from a3pi' do
          expect(article.author).to be_a ACTV::Author
        end
      end
      context 'when the author does not exist in a3pi' do
        before do
          allow(ACTV).to receive(:asset).and_raise ACTV::Error::NotFound
        end
        it 'returns an author asset from the article hash' do
          expect(article.author).to be_a ACTV::Author
        end
      end
    end
    context 'when an author reference does not exist' do
      it 'returns an author asset' do
        expect(article.author).to be_a ACTV::Author
      end
    end
  end
end
