require "spec_helper"

describe "assets" do
  let(:app) { Octodmin::App.new }

  describe "css" do
    before { get "/assets/app.css" }
    subject { last_response.body }

    it "returns css" do
      expect(subject).to include("@charset")
    end
  end

  describe "js" do
    before { get "/assets/app.js" }
    subject { last_response.body }

    it "returns js" do
      expect(subject).to include("App = React.createClass")
    end
  end
end
