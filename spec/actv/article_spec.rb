require 'spec_helper'

describe ACTV::Article do
  context "shoulda matchers" do
    subject { ACTV::Article.new(assetGuid: 1) }

    it { should respond_to :summary }
    it { should respond_to :description }
    it { should respond_to :by_line }
    it { should respond_to :author_bio }
    it { should respond_to :author_photo }
    it { should respond_to :source }
    it { should respond_to :type }
    it { should respond_to :image }
    it { should respond_to :subtitle }
    it { should respond_to :footer }
    it { should respond_to :inline_ad }
    it { should respond_to :inline_ad? }
  end

  describe '#inline_ad?' do
    context 'if inlindead is set to true' do
      let(:article) { ACTV::Article.new(assetGuid: 1, assetTags: [ { tag: { tagId: '1', tagName: 'true', tagDescription: 'inlinead' } } ]) }
      it 'should return true' do
        article.inline_ad?.should eq true
      end
    end

    context 'if inlindead is set to false' do
      let(:article) { ACTV::Article.new(assetGuid: 1, assetTags: [ { tag: { tagId: '1', tagName: 'false', tagDescription: 'inlinead' } } ]) }
      it 'should return false' do
        article.inline_ad?.should eq false
      end
    end

    context 'if inlindead is not set' do
      let(:article) { ACTV::Article.new assetGuid: 1 }

      it 'should return true' do
        article.inline_ad?.should eq true
      end
    end
  end
end