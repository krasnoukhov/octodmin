require "spec_helper"

describe "syncs" do
  let(:date) { Date.today.strftime("%Y-%m-%d") }
  let(:app) { Octodmin::App.new(File.expand_path("../..", __dir__)) }

  before do
    allow_any_instance_of(Git::Base).to receive(:pull).and_return(nil)
    allow_any_instance_of(Git::Base).to receive(:push).and_return(nil)
  end

  describe "create" do
    context "invalid" do
      before do
        allow_any_instance_of(Git::Base).to receive(:pull).and_raise(Git::GitExecuteError, "Git error")

        post "/api/posts", title: "Blah"
        post "/api/syncs"
      end
      after { File.delete("sample/_posts/#{date}-blah.markdown") }
      subject { parse_json(last_response.body)["errors"] }

      it "returns errors" do
        expect(last_response).to_not be_ok
        expect(subject).to eql(["Git error"])
      end
    end

    context "valid" do
      context "no changes" do
        before do
          post "/api/syncs"
        end
        subject { parse_json(last_response.body)["syncs"] }

        it "returns errors" do
          expect(subject).to eql(["Everything is up-to-date"])
        end
      end

      context "with changes" do
        before do
          allow_any_instance_of(Git::Base).to receive(:commit).and_return(nil)

          # Create post
          post "/api/posts", title: "Yo"

          # Update post
          patch "/api/posts/2015-01-30-test", {
            layout: "other",
            title: "Test",
            slug: "test",
            date: "2015-01-30 18:10:00",
            content: "### WOW",
          }

          # Delete post
          delete "/api/posts/2015-01-30-welcome-to-jekyll"

          post "/api/syncs"
        end
        after do
          File.delete("sample/_posts/#{date}-yo.markdown")
          git = Git.open(Octodmin::App.dir)
          git.checkout("sample/_posts/2015-01-30-test.markdown")
          git.checkout("sample/_posts/2015-01-30-welcome-to-jekyll.markdown")
        end
        subject { parse_json(last_response.body)["syncs"] }

        it "returns syncs" do
          expect(subject).to eql(["Octodmin sync for 3 files\n\n_posts/#{date}-yo.markdown\n_posts/2015-01-30-welcome-to-jekyll.markdown\n_posts/2015-01-30-test.markdown"])
        end
      end
    end
  end
end
