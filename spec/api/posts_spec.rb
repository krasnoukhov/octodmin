require "spec_helper"

describe "posts" do
  let(:app) { Octodmin::App.new }

  describe "index" do
    before { get "/api/posts" }
    subject { parse_json(last_response.body)["posts"] }

    it "returns posts" do
      expect(subject.count).to eql(2)
      expect(subject.first["identifier"]).to eql("_2015_01_30_test")
      expect(subject.first["title"]).to eql("Test")
      expect(subject.first["excerpt"]).to eql("# OMG\n\n")
    end
  end

  describe "show" do
    before { get "/api/posts/_2015_01_30_test" }
    subject { parse_json(last_response.body)["posts"] }

    it "returns post" do
      expect(subject["identifier"]).to eql("_2015_01_30_test")
      expect(subject["title"]).to eql("Test")
      expect(subject["path"]).to eql("_posts/2015-01-30-test.markdown")
      expect(subject["date"]).to eql("2015-01-30 18:00:47 +0200")
      expect(subject["content"]).to eql("# OMG\n\nThis is a *post*!\n")
    end
  end
end
