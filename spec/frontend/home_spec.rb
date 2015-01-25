require "spec_helper"

describe "home" do
  let(:app) { Octodmin::App.new }

  describe "home" do
    before { get "/" }
    subject { last_response.body }

    it "returns home" do
      expect(subject).to include("<!DOCTYPE html>")
      expect(subject).to include("/assets/app.css")
      expect(subject).to include("/assets/app.js")
    end
  end
end
