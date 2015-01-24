require "spec_helper"

describe "version" do
  let(:app) { Octodmin::App.new }

  describe "show" do
    before { get "/api/version" }
    subject { parse_json(last_response.body)["versions"] }

    it "returns version" do
      expect(subject).to eql(Octodmin::VERSION)
    end
  end
end
