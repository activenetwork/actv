require 'spec_helper'
require "active_support/time"
require "pry"

describe ACTV::Evergreen do
  before do
    stub_get("/v2/assets/valid_evergreen.json").to_return(body: fixture("valid_evergreen.json"), headers: { content_type: "application/json; charset=utf-8" })
    stub_get("/v2/assets/068487f1-807f-4fcd-8561-53740f80f6b3.json").to_return(body: fixture("valid_evergreen_child_1.json"), headers: { content_type: "application/json; charset=utf-8" })
  end

  subject { ACTV.event('valid_evergreen') }

  def format_date date
    date.strftime('%Y-%m-%dT%H:%M:%S')
  end
  def format_date_in_utc date
    format_date(date) << ' UTC'
  end

  # describe "available methods" do
  #   subject { ACTV::Event.new(assetGuid: 1) }
  #   it { should respond_to :online_registration_available? }
  #   it { should respond_to :registration_not_yet_open? }
  #   it { should respond_to :registration_open? }
  #   it { should respond_to :registration_closed? }
  #   it { should respond_to :event_ended? }
  # end

  describe "evergreen?" do
    its(:evergreen?) { should be_true }
  end
end

