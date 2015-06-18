require 'spec_helper'

describe ACTV::Author do
  let(:author_name) { "" }
  let(:asset_descriptions) { {} }
  let(:response) { { assetGuid: "777",
                     assetDescriptions: asset_descriptions,
                     authorName: author_name} }
  subject(:author) { ACTV::Author.new response }
  subject(:author_from_article) { ACTV::Author.build_from_article response }

  describe '#name' do
    let(:asset_descriptions) { [ { descriptionType: { descriptionTypeId: "3",
                                                    descriptionTypeName: "authorFooter" },
                                   description: "<span class='author-name'>Bob Marley</span>" } ] }
    context 'when the author is created from an article' do
      let(:author_name) { "Jimi Hendrix" }
      it 'returns the author name from the article' do
        expect(author_from_article.name).to eq "Jimi Hendrix"
      end
    end
    context 'when the author is created from an author' do
      it 'returns the author name from the author footer' do
        expect(author.name).to eq "Bob Marley"
      end
    end
  end

end
