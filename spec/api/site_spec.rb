require "spec_helper"

describe "site" do
  let(:app) { Octodmin::App.new(File.expand_path("../..", __dir__)) }

  describe "show" do
    before { get "/api/site" }
    subject { parse_json(last_response.body)["sites"] }

    it "returns site" do
      expect(subject["title"]).to eql("Your awesome title")
    end

    it "returns octodmin config" do
      expect(subject["octodmin"]["front_matter"].keys).to eq(["layout", "title", "date", "custom"])
    end
  end
end
