require "spec_helper"

describe "deploys" do
  let(:app) { Octodmin::App.new(File.expand_path("../..", __dir__)) }

  before do
    expect(Octopress::Deploy).to receive(:push).once
  end

  describe "create" do
    context "invalid" do
      before do
        allow(Octopress::Deploy).to receive(:push).and_raise(SystemExit, "Deploy error")
        post "/api/deploys"
      end
      subject { parse_json(last_response.body)["errors"] }

      it "returns errors" do
        expect(last_response).to_not be_ok
        expect(subject).to eql(["Deploy error"])
      end
    end

    context "valid" do
      before do
        allow(Octopress::Deploy).to receive(:push).and_return(nil)
        post "/api/deploys"
      end
      subject { parse_json(last_response.body)["deploys"] }

      it "returns errors" do
        expect(subject).to eql(["Deployed successfully"])
      end
    end
  end
end
