require 'spec_helper'

describe ACTV::Author do
  before do
    stub_request(:post, "http://api.amp.active.com/v2/assets.json").
      to_return(body: fixture("valid_author.json"))
  end
  subject(:author) { ACTV.asset('author_id').first }


  context 'when valid author asset is initialized' do
    its(:footer) { should start_with '<div class="article-signature-block">' }
    its(:bio) { should start_with 'Jacquie Cattanach is an avid runner and triathlete' }
    its('photo.url') {should eq 'http://www.active.com/Assets/Running/Bios/jacquie-cattanach-bio.jpg'}
    its(:name_from_footer) { should eq 'Jacquie Cattanach'}
  end

  describe '#image_url' do
    context 'when photo url is a fully qualified url' do
      it 'returns the photo url' do
        expect(author.image_url).to eq 'http://www.active.com/Assets/Running/Bios/jacquie-cattanach-bio.jpg'
      end
    end

    context 'when photo url starts with /' do
      before do
        allow(author.photo).to receive(:url).and_return '/hello'
      end
      it 'returns the url for the active.com domain' do
        expect(author.image_url).to eq 'http://www.active.com/hello'
      end
    end
  end

  describe '#name' do
    context 'when the author is created from an article' do
      let(:author_name) { "" }
      let(:asset_descriptions) { {} }
      let(:response) { { assetGuid: "777",
                         assetDescriptions: asset_descriptions,
                         authorName: author_name} }
      let(:author_from_article) { ACTV::Author.build_from_article response }

      context 'when author name exists in the author footer' do
        let(:asset_descriptions) { [ { descriptionType: { descriptionTypeId: "3",
                                                          descriptionTypeName: "authorFooter" },
                                       description: "<span class='author-name'>Bob Marley</span>" } ] }
        let(:author_name) { "Jimi Hendrix" }

        it 'returns the author name from the article footer' do
          expect(author_from_article.name).to eq "Bob Marley"
        end
      end

      context 'when author name exists only in the author name field' do
        let(:author_name) { "Jimi Hendrix" }
        it 'returns author name from the author name field' do
          expect(author_from_article.name).to eq 'Jimi Hendrix'
        end
      end
    end

    context 'when the author is created from an author' do
      it 'returns the author name from the author footer' do
        expect(author.name).to eq "Jacquie Cattanach"
      end
    end
  end

end
