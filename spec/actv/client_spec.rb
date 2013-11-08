require 'spec_helper'

describe ACTV::Client do

  subject do
    client = ACTV::Client.new
    # client.class_eval{public *ACTV::Client.private_instance_methods}
    client
  end

  context "with module configuration" do

    before  do
      ACTV.configure do |config|
        ACTV::Configurable.keys.each do |key|
          config.send("#{key}=", key)
        end
      end
    end

    after do
      ACTV.reset!
    end

    it "inherits the module configuration" do
      client = ACTV::Client.new
      ACTV::Configurable.keys.each do |key|
        client.instance_variable_get("@#{key}").should eq key
      end
    end

    context "with class configuration" do

      before do
        @configuration = {
          :connection_options => {:timeout => 10},
          :consumer_key => 'CK',
          :consumer_secret => 'CS',
          :endpoint => 'http://tumblr.com/',
          :media_endpoint => 'http://upload.twitter.com',
          :middleware => Proc.new{},
          :oauth_token => 'OT',
          :oauth_token_secret => 'OS',
          :search_endpoint => 'http://search.twitter.com',
          :api_key => 'TEST'
        }
      end

      context "during initialization" do
        it "overrides the module configuration" do
          client = ACTV::Client.new(@configuration)
          ACTV::Configurable.keys.each do |key|
            client.instance_variable_get("@#{key}").should eq @configuration[key]
          end
        end
      end

      context "after initilization" do
        it "overrides the module configuration after initialization" do
          client = ACTV::Client.new
          client.configure do |config|
            @configuration.each do |key, value|
              config.send("#{key}=", value)
            end
          end
          ACTV::Configurable.keys.each do |key|
            client.instance_variable_get("@#{key}").should eq @configuration[key]
          end
        end
      end

    end

  end

  describe "#credentials?" do
    it "returns true if all credentials are present" do
      client = ACTV::Client.new(:consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT', :oauth_token_secret => 'OS')
      client.credentials?.should be_true
    end
    # it "returns false if any credentials are missing" do
    #   client = ACTV::Client.new(:consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT')
    #   client.credentials?.should be_false
    # end
  end

  describe "#connection" do
    it "looks like Faraday connection" do
      subject.connection.should respond_to(:run_request)
    end
    it "memoizes the connection" do
      c1, c2 = subject.connection, subject.connection
      c1.object_id.should eq c2.object_id
    end
  end

  describe "#request" do
    before do
      @client = ACTV::Client.new({:consumer_key => "CK", :consumer_secret => "CS", :oauth_token => "OT", :oauth_token_secret => "OS"})
    end

    it "does something" do
      stub_request(:get, "http://api.amp.active.com/system_health").
        with(:headers => {'Accept'=>'application/json'}).
        to_return(:status => 200, :body => '{"status":"not implemented"}', :headers => {})

      @client.request(:get, "/system_health", {}, {})[:body].should eql({status: "not implemented"})
    end

    it "encodes the entire body when no uploaded media is present" do
    #   stub_post("/1/statuses/update.json").
    #     with(:body => {:status => "Update"}).
    #     to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    #   @client.update("Update")
    #   a_post("/1/statuses/update.json").
    #     with(:body => {:status => "Update"}).
    #     should have_been_made
    end
    # it "encodes none of the body when uploaded media is present" do
    #   stub_post("/1/statuses/update_with_media.json", "https://upload.twitter.com").
    #     to_return(:body => fixture("status_with_media.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    #   @client.update_with_media("Update", fixture("pbjt.gif"))
    #   a_post("/1/statuses/update_with_media.json", "https://upload.twitter.com").
    #     should have_been_made
    # end
    # it "catches Faraday errors" do
    #   subject.stub!(:connection).and_raise(Faraday::Error::ClientError.new("Oups"))
    #   lambda do
    #     subject.request(:get, "/path", {}, {})
    #   end.should raise_error(Twitter::Error::ClientError, "Oups")
    # end
  end

  describe '#asset' do
    let(:client) { ACTV::Client.new({:consumer_key => "CK", :consumer_secret => "CS", :oauth_token => "OT", :oauth_token_secret => "OS"}) }

    context 'find asset' do
      before do
        stub_request(:get, "http://api.amp.active.com/v2/assets/asset_id.json").
          to_return(body: fixture("valid_asset.json"), headers: { content_type: "application/json; charset=utf-8" })
      end

      it 'should make a normal asset call' do
        client.asset('asset_id')[0].should be_a ACTV::Asset
      end
    end

    context 'preview asset' do
      before do
        stub_request(:get, "http://api.amp.active.com/v2/assets/asset_id/preview.json").
          to_return(body: fixture("valid_asset.json"), headers: { content_type: "application/json; charset=utf-8" })
      end

      it 'should make preview call' do
        client.asset('asset_id', {preview: 'true'})[0].should be_a ACTV::Asset
      end
    end
  end

  ACTV::Configurable::CONFIG_KEYS.each do |key|
    it "has a default #{key.to_s.gsub('_', ' ')}" do
      subject.send(key).should eq ACTV::Default.options[key]
    end
  end

end
