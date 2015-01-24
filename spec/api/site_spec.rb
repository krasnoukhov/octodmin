require "spec_helper"

describe "site" do
  let(:app) { Octodmin::App.new }

  describe "show" do
    before { get "/api/site" }
    subject { parse_json(last_response.body)["sites"] }

    it "returns site" do
      expect(subject["title"]).to eql("Your awesome title")
    end
  end
end
