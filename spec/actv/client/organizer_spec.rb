require 'spec_helper'

describe ACTV::Client do
  before do
    @client = ACTV::Client.new
  end

  describe "#organizer" do
    context "with a valid asset ID passed" do
     before do
        stub_get("/v3/organizers/valid_organizer.json").
          to_return(body: fixture("valid_organizer.json"))
        @organizer = @client.organizer("valid_organizer")
     end

     it "requests the correct asset" do
       a_get("/v3/organizers/valid_organizer.json").should have_been_made
     end

     it "returns the correct id" do
       @organizer.id.should == "3f9d9266-1e44-4871-a9cb-48d876fcdcd0"
     end
     it "returns the correct name" do
       @organizer.name.should == "test org name"
     end
     it "returns the correct description" do
       @organizer.description.should == "test org dsc"
     end
     it "returns the correct address_line1" do
       @organizer.address_line1.should == "addy 1"
     end
     it "returns the correct address_line2" do
       @organizer.address_line2.should == "addy 2"
     end
     it "returns the correct city" do
       @organizer.city.should == "city"
     end
     it "returns the correct locality" do
       @organizer.locality.should == "locality"
     end
     it "returns the correct state" do
       @organizer.state.should == "CA"
     end
     it "returns the correct country" do
       @organizer.country.should == "US"
     end
     it "returns the correct postal_code" do
       @organizer.postal_code.should == "82828"
     end
     it "returns the correct primary_contact" do
       @organizer.primary_contact.should == "org contact name"
     end
     it "returns the correct email" do
       @organizer.email.should == "org email"
     end
     it "returns the correct phone" do
       @organizer.phone.should == "888-555-1234"
     end
    end
  end

  describe "#organizers" do
    context "with a valid asset ID passed" do
     before do
        stub_get("/v3/organizers.json").
          to_return(body: fixture("valid_organizers.json"))
        @organizers = @client.organizers
     end
     it "returns an array of organizers" do
       @organizers.total.should == 34968
       @organizers.results.first.should be_a ACTV::Organizer
     end
    end
  end
end
