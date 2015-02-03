require "spec_helper"

shared_examples_for "existing post" do
  it "has post" do
    expect(subject["identifier"]).to eql("2015-01-30-test")
    expect(subject["deleted"]).to eql(false)
    expect(subject["title"]).to eql("Test")
    expect(subject["path"]).to eql("_posts/2015-01-30-test.markdown")
    expect(subject["date"]).to eql("2015-01-30 20:10:00 +0200")
    expect(subject["content"]).to eql("# OMG\n\nThis is a *post*!\n")
    expect(subject["custom"]).to eql("data")
  end
end

shared_examples_for "new post" do
  it "has post" do
    expect(File.exists?("sample/_posts/#{date}-new-one.markdown")).to be_truthy
    expect(subject["identifier"]).to eql("#{date}-new-one")
    expect(subject["deleted"]).to eql(false)
    expect(subject["title"]).to eql("New One")
    expect(subject["path"]).to eql("_posts/#{date}-new-one.markdown")
    expect(subject["date"]).to start_with(date)
    expect(subject["content"]).to eql("New post from **template**\n")
    expect(subject["custom"]).to eql("default")
  end
end

shared_examples_for "updated post" do
  it "has post" do
    expect(File.exists?("sample/_posts/#{date}-new-one.markdown")).to be_falsy
    expect(File.exists?("sample/_posts/#{date}-updated-one.markdown")).to be_truthy
    expect(subject["identifier"]).to eql("#{date}-updated-one")
    expect(subject["deleted"]).to eql(false)
    expect(subject["title"]).to eql("Updated One")
    expect(subject["path"]).to eql("_posts/#{date}-updated-one.markdown")
    expect(subject["date"]).to start_with(date)
    expect(subject["content"]).to eql("### WOW\n")
    expect(subject["custom"]).to eql("updated")
    expect(subject.has_key?("junk")).to be_falsy
  end
end

shared_examples_for "deleted post" do
  it "has no post" do
    expect(File.exists?("sample/_posts/2015-01-30-welcome-to-jekyll.markdown")).to be_truthy
    expect(subject["identifier"]).to eql("2015-01-30-welcome-to-jekyll")
    expect(subject["deleted"]).to eql(true)
    expect(subject["title"]).to eql("Welcome to Jekyll!")
  end
end

describe "posts" do
  let(:app) { Octodmin::App.new(File.expand_path("../..", __dir__)) }
  let(:date) { Date.today.strftime("%Y-%m-%d") }

  describe "index" do
    before { get "/api/posts" }
    subject { parse_json(last_response.body)["posts"] }

    context "first post" do
      subject { parse_json(last_response.body)["posts"].first }
      it_behaves_like "existing post"
    end

    context "last post" do
      specify do
        expect(subject.last["identifier"]).to eql("2015-01-30-welcome-to-jekyll")
        expect(subject.last["title"]).to eql("Welcome to Jekyll!")
      end
    end
  end

  describe "create" do
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

      context "response" do
        it_behaves_like "new post"
      end

      context "request" do
        before { get "/api/posts/#{date}-new-one" }
        it_behaves_like "new post"
      end
    end
  end

  describe "show" do
    before { get "/api/posts/2015-01-30-test" }
    subject { parse_json(last_response.body)["posts"] }
    it_behaves_like "existing post"
  end

  describe "update" do
    before do
      post "/api/posts", title: "New One"
      patch "/api/posts/#{date}-new-one", {
        layout: "post",
        title: "Updated One",
        date: "#{date} 00:00:00",
        content: "### WOW",
        custom: "updated",
        junk: "shit",
      }
    end
    after do
      File.delete("sample/_posts/#{date}-updated-one.markdown")
    end
    subject { parse_json(last_response.body)["posts"] }

    context "response" do
      it_behaves_like "updated post"
    end

    context "request" do
      before { get "/api/posts/#{date}-updated-one" }
      it_behaves_like "updated post"
    end
  end

  describe "delete" do
    before do
      delete "/api/posts/2015-01-30-welcome-to-jekyll"
    end
    after do
      git = Git.open(Octodmin::App.dir)
      git.add("sample/_posts/2015-01-30-welcome-to-jekyll.markdown")
    end
    subject { parse_json(last_response.body)["posts"] }
    it_behaves_like "deleted post"
  end
end
