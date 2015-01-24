require "spec_helper"

describe "posts" do
  let(:app) { Octodmin::App.new }

  describe "index" do
    before { get "/api/posts" }
    subject { parse_json(last_response.body)["posts"] }

    it "returns posts" do
      expect(subject.count).to eql(2)
      expect(subject.first["title"]).to eql("Test")
      expect(subject.first["path"]).to eql("_posts/2015-01-30-test.markdown")
    end
  end
end
