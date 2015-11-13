require 'spec_helper'

describe ACTV::Client do

  let(:configuration) { {} }

  subject(:client) { ACTV::Client.new configuration }

  describe '#find_by_endurance_id' do
    before { allow(client).to receive(:get).and_return response }

    context 'when there are no results' do
      let(:response) do
        {method: :get, body: {results: []}}
      end

      it 'returns an empty array' do
        allow(client).to receive(:get).and_return response
        expect(client.find_by_endurance_id 1234).to eq []
      end
    end

    context 'when there is one result' do
      let(:response) do
        {method: :get, body: {results: [
          { assetGuid: "long ass guid",
            registrationUrlAdr: 'blah?e=1234',
            assetParentAsset: {} }
        ]}}
      end

      it 'returns an array with one object' do
        expect(client.find_by_endurance_id(1234).count).to eq 1
      end

      it 'returns an array of one asset' do
        expect(client.find_by_endurance_id(1234).first).to be_an ACTV::Asset
      end
    end

    context 'when there are more than result' do
      let(:response) do
        {method: :get, body: {results: [
          { assetGuid: 'child asset guid',
            registrationUrlAdr: 'blah?e=1234',
            assetParentAsset: { assetGuid: 'parent asset guid' } },
          { assetGuid: 'parent asset guid',
            registrationUrlAdr: 'blah?e=1234',
            assetParentAsset: {} }
        ]}}
      end

      it 'returns an array with one object' do
        expect(client.find_by_endurance_id(1234).count).to eq 1
      end

      it 'returns an array of one asset' do
        expect(client.find_by_endurance_id(1234).first).to be_an ACTV::Asset
      end

      it 'returns the parent asset' do
        expect(client.find_by_endurance_id(1234).first.assetGuid).to eq 'parent asset guid'
      end
    end
  end

  context "with module configuration" do
    before do
      ACTV.configure do |config|
        ACTV::Configurable.keys.each do |key|
          config.send("#{key}=", key)
        end
      end
    end

    after { ACTV.reset! }

    it "inherits the module configuration" do
      ACTV::Configurable.keys.each do |key|
        expect(client.instance_variable_get "@#{key}").to eq key
      end
    end

    context "with class configuration" do

      let(:configuration) do
        { connection_options: {timeout: 10},
          consumer_key: 'CK',
          consumer_secret: 'CS',
          endpoint: 'http://tumblr.com/',
          media_endpoint: 'http://upload.twitter.com',
          middleware: Proc.new{},
          oauth_token: 'OT',
          oauth_token_secret: 'OS',
          search_endpoint: 'http://search.twitter.com',
          api_key: 'TEST' }
      end

      context "during initialization" do
        it "overrides the module configuration" do
          ACTV::Configurable.keys.each do |key|
            expect(client.instance_variable_get "@#{key}").to eq configuration[key]
          end
        end
      end

      context "after initilization" do
        it "overrides the module configuration after initialization" do
          client = ACTV::Client.new
          client.configure do |config|
            configuration.each do |key, value|
              config.send("#{key}=", value)
            end
          end
          ACTV::Configurable.keys.each do |key|
            expect(client.instance_variable_get "@#{key}").to eq configuration[key]
          end
        end
      end

    end
  end

  describe "#credentials?" do
    it "returns true if all credentials are present" do
      client = ACTV::Client.new(consumer_key: 'CK', consumer_secret: 'CS', oauth_token: 'OT', oauth_token_secret: 'OS')
      expect(client.credentials?).to be_true
    end
    it "returns false if any credentials are missing" do
      expect(client.credentials?).to be_false
    end
  end

  describe "#connection" do
    it "looks like Faraday connection" do
      expect(client.connection).to respond_to(:run_request)
    end
    it "memoizes the connection" do
      expect(client.connection.object_id).to eq client.connection.object_id
    end
  end

  describe "#request" do
    let(:configuration) do
      { consumer_key: "CK",
        consumer_secret: "CS",
        oauth_token: "OT",
        oauth_token_secret: "OS" }
    end

    it "makes a request" do
      stub_request(:get, "http://api.amp.active.com/system_health").
        with(headers: {'Accept'=>'application/json'}).
        to_return(status: 200, body: '{"status":"not implemented"}', headers: {})

      expect(client.request(:get, "/system_health", {}, {})[:body]).to eql status: "not implemented"
    end
  end

  describe '#articles' do
    before do
      stub_request(:get, "http://api.amp.active.com/v2/search.json").with(query: {query: '', category: 'camps AND articles'}).
          to_return(body: fixture("valid_articles.json"), headers: { content_type: "application/json; charset=utf-8" })
    end
    it 'should return 2 camps articles when request category is camps' do
      articles = client.articles('', {}, ['camps']).results
      expect(articles.size).to eq 2
      expect(articles[0]).to be_an ACTV::Article
      expect(articles[0].category_is?('camps')).to be_true
      expect(articles[1].category_is?('camps')).to be_true
    end
  end

  describe '#events' do
    before do
      stub_request(:get, "http://api.amp.active.com/v2/search.json").with(query: {query: '', category: 'camps AND event'}).
          to_return(body: fixture("valid_camps_events.json"), headers: { content_type: "application/json; charset=utf-8" })
      stub_request(:get, "http://api.amp.active.com/v2/search.json").with(query: {query: '', category: 'event'}).
          to_return(body: fixture("valid_all_events.json"), headers: { content_type: "application/json; charset=utf-8" })
    end
    it 'should return 2 camps events when request category is camps' do
      events = client.events('', {}, ['camps']).results
      expect(events.size).to eq 2
      expect(events[0]).to be_an ACTV::Event
      expect(events[0].category_is?('camps')).to be_true
      expect(events[1].category_is?('camps')).to be_true
    end

    it 'should return 3 events which are not camps when request category is camps' do
      events = client.events('').results
      expect(events.size).to eq 3
      expect(events[0]).to be_an ACTV::Event
      expect(events[0].category_is?('camps')).to be_false
      expect(events[1].category_is?('camps')).to be_false
      expect(events[2].category_is?('camps')).to be_false
    end
  end

  describe '#article' do
    let(:configuration) do
      { consumer_key: "CK",
        consumer_secret: "CS",
        oauth_token: "OT",
        oauth_token_secret: "OS"}
    end

    context 'find article' do
      before do
        stub_request(:get, "http://api.amp.active.com/v2/assets/asset_id.json").
          to_return(body: fixture("valid_article.json"), headers: { content_type: "application/json; charset=utf-8" })
      end

      it 'makes a normal asset call' do
        expect(client.article 'asset_id').to be_an ACTV::Article
      end
    end

    context 'preview article' do
      context 'when preview is true' do
        before do
          stub_request(:get, "http://api.amp.active.com/v2/assets/asset_id/preview.json").
            to_return(body: fixture("valid_article.json"), headers: { content_type: "application/json; charset=utf-8" })
        end

        it 'returns an article' do
          expect(client.article 'asset_id', preview: 'true').to be_an ACTV::Article
        end
      end

      context 'when preview is false' do
        before do
          stub_request(:get, "http://api.amp.active.com/v2/assets/asset_id.json").
            to_return(body: fixture("valid_article.json"), headers: { content_type: "application/json; charset=utf-8" })
        end

        it 'returns an article' do
          expect(client.article 'asset_id', preview: 'false').to be_an ACTV::Article
        end
      end
    end
  end

  describe '#event' do
    let(:configuration) do
      { consumer_key: "CK",
        consumer_secret: "CS",
        oauth_token: "OT",
        oauth_token_secret: "OS"}
    end

    context 'find event' do
      before do
        stub_request(:get, "http://api.amp.active.com/v2/assets/asset_id.json").
          to_return(body: fixture("valid_event.json"), headers: { content_type: "application/json; charset=utf-8" })
      end

      it 'makes a normal asset call' do
        expect(client.event 'asset_id').to be_an ACTV::Event
      end
    end

    context 'when multiple event ids' do
      before do
        stub_request(:get, "http://api.amp.active.com/v2/assets/asset_ids.json").
          to_return(body: fixture("valid_events.json"), headers: { content_type: "application/json; charset=utf-8" })
      end

      it 'returns an Array of Events' do
        client.event('asset_ids').each do |asset|
          expect(asset).to be_an ACTV::Event
        end
      end
    end

    context 'preview event' do
      context 'when preview is true' do
        before do
          stub_request(:get, "http://api.amp.active.com/v2/assets/asset_id/preview.json").
            to_return(body: fixture("valid_event.json"), headers: { content_type: "application/json; charset=utf-8" })
        end

        it 'returns an event' do
          expect(client.event 'asset_id', preview: 'true').to be_an ACTV::Event
        end
      end

      context 'when preview is false' do
        before do
          stub_request(:get, "http://api.amp.active.com/v2/assets/asset_id.json").
            to_return(body: fixture("valid_event.json"), headers: { content_type: "application/json; charset=utf-8" })
        end

        it 'returns an event' do
          expect(client.event 'asset_id', preview: 'false').to be_an ACTV::Event
        end
      end
    end
  end

  describe '#asset' do
    let(:configuration) do
      { consumer_key: "CK",
        consumer_secret: "CS",
        oauth_token: "OT",
        oauth_token_secret: "OS"}
    end
    let(:fixture_asset) { "valid_asset.json" }
    let(:request_type) { :post }
    let(:endpoint) { "http://api.amp.active.com/v2/assets.json" }
    let(:asset) { client.asset('asset_id').first }
    let(:assets) { client.asset('author_guid,article_guid,event_guid') }
    before do
      stub_request(request_type, endpoint).
        to_return(body: fixture(fixture_asset), headers: { content_type: "application/json; charset=utf-8" })
    end

    context 'when an asset guid with no category is passed' do
      it 'returns an event' do
        expect(asset).to be_an ACTV::Asset
      end
    end
    context 'when an event guid is passed' do
      let(:fixture_asset) { "valid_event.json" }
      it 'returns an event' do
        expect(asset).to be_an ACTV::Event
      end
    end
    context 'when an article guid is passed' do
      let(:fixture_asset) { "valid_article.json" }
      it 'returns an article' do
        expect(asset).to be_an ACTV::Article
      end
    end
    context 'when an author guid is passed' do
      let(:fixture_asset) { "valid_author.json" }
      it 'returns an author' do
        expect(asset).to be_an ACTV::Author
      end
    end
    context 'when multiple asset guids are passed' do
      let(:fixture_asset) { "valid_assets.json" }
      it 'returns an author' do
        expect(assets.first).to be_an ACTV::Author
      end
      it 'returns an article' do
        expect(assets[1]).to be_an ACTV::Article
      end
      it 'returns an event' do
        expect(assets.last).to be_an ACTV::Event
      end
    end
    context 'when a preview key is provided' do
      context 'when preview is true' do
        let(:request_type) { :get }
        let(:endpoint) { "http://api.amp.active.com/v2/assets/asset_id/preview.json" }
        let(:asset) { client.asset('asset_id', preview: 'true').first }
        it 'returns an asset' do
          expect(asset).to be_an ACTV::Asset
        end
      end
      context 'when preview is false' do
        let(:endpoint) { "http://api.amp.active.com/v2/assets.json" }
        let(:asset) { client.asset('asset_id', preview: 'false').first }
        it 'returns an asset' do
          expect(asset).to be_an ACTV::Asset
        end
      end
    end
  end

  ACTV::Configurable::CONFIG_KEYS.each do |key|
    it "has a default #{key.to_s.gsub('_', ' ')}" do
      expect(client.send key).to eq ACTV::Default.options[key]
    end
  end

end
