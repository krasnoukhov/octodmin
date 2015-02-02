require "spec_helper"

describe "posts" do
  let(:app) { Octodmin::App.new }

  describe "index" do
    before { get "/api/posts" }
    subject { parse_json(last_response.body)["posts"] }

    it "returns posts" do
      expect(subject.count).to eql(2)
      expect(subject.first["identifier"]).to eql("2015-01-30-test")
      expect(subject.first["title"]).to eql("Test")
      expect(subject.first["excerpt"]).to eql("# OMG\n\n")
      expect(subject.first["custom"]).to eql("data")

      expect(subject.last["identifier"]).to eql("2015-01-30-welcome-to-jekyll")
      expect(subject.last["title"]).to eql("Welcome to Jekyll!")
    end
  end

  describe "show" do
    before { get "/api/posts/2015-01-30-test" }
    subject { parse_json(last_response.body)["posts"] }

    it "returns post" do
      expect(subject["identifier"]).to eql("2015-01-30-test")
      expect(subject["title"]).to eql("Test")
      expect(subject["path"]).to eql("_posts/2015-01-30-test.markdown")
      expect(subject["date"]).to eql("2015-01-30 18:00:47 +0200")
      expect(subject["content"]).to eql("# OMG\n\nThis is a *post*!\n")
      expect(subject["custom"]).to eql("data")
    end
  end

  describe "create" do
    let(:date) { Date.today.strftime("%Y-%m-%d") }

    context "invalid" do
      context "no title" do
        before { post "/api/posts" }

        it "is not ok" do
          expect(last_response).to_not be_ok
          expect(last_response.body).to include("Required param `title` is not specified")
        end
      end

      context "same title" do
        before do
          post "/api/posts", title: "Yo"
          post "/api/posts", title: "Yo"
        end
        after { File.delete("sample/_posts/#{date}-yo.markdown") }

        it "is not ok" do
          expect(last_response).to_not be_ok
          expect(last_response.body).to include("Post with specified `title` already exists")
        end
      end
    end

    context "valid" do
      before { post "/api/posts", title: "New One" }
      after { File.delete("sample/_posts/#{date}-new-one.markdown") }
      subject { parse_json(last_response.body)["posts"] }

      it "creates post" do
        expect(subject["identifier"]).to eql("#{date}-new-one")
        expect(subject["title"]).to eql("New One")
        expect(subject["path"]).to eql("_posts/#{date}-new-one.markdown")
        expect(subject["date"]).to start_with(date)
        expect(subject["content"]).to eql("New post from **template**\n")
        expect(subject["custom"]).to eql("default")
      end
    end
  end
end
