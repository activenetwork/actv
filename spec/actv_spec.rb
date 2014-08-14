require 'spec_helper'

describe ACTV do

  after do
    ACTV.reset!
  end

  context "when delegating to a client" do
      
    before do
      stub_post("/v2/assets.json").with(:body => {"id"=>"valid_asset"}).
      to_return(body: fixture("valid_asset.json"), headers: { content_type: "application/json; charset=utf-8" })
    end

    it "requests the correct resource" do
      ACTV.asset('valid_asset')
      a_post("/v2/assets.json").should have_been_made
    end

    it "returns the same results as a client" do
      ACTV.asset('valid_asset').should eq ACTV::Client.new.asset('valid_asset')
    end

  end

  describe '.respond_to?' do
    it "delegates to ACTV::Client" do
      ACTV.respond_to?(:asset).should be_true
    end

    it "takes an optional argument" do
      ACTV.respond_to?(:asset, true).should be_true
    end
  end

  describe ".client" do
    it "returns a ACTV::Client" do
      ACTV.client.should be_a ACTV::Client
    end
  end

  describe ".configure" do
    ACTV::Configurable.keys.each do |key|
      it "sets the #{key.to_s.gsub('_', ' ')}" do
        ACTV.configure do |config|
          config.send("#{key}=", key)
        end
        ACTV.instance_variable_get("@#{key}").should eq key
      end
    end
  end

  ACTV::Configurable::CONFIG_KEYS.each do |key|
    it "has a default #{key.to_s.gsub('_', ' ')}" do
      ACTV.send(key).should eq ACTV::Default.options[key]
    end
  end

end
