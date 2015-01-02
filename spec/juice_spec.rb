require_relative "spec_helper.rb"

describe "juice" do
  let(:username) { "user" }
  let(:app) { Sinatra::Application}

  describe "/" do
    it "should work" do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to include("Sign in securely via")
    end
  end
end
