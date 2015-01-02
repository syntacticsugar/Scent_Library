require_relative "spec_helper.rb"

describe Juice do
  let(:username) { "user" }
  let(:app) { Sinatra::Application}

  describe "GET /juice/:id" do
    pending "create tests"

    it "should work" do
      get '/juice/0'
      expect(last_response).to be_ok
    end
  end

  describe "GET juice/:id/edit" do
    pending "create tests"
  end

  describe "GET juice/:id/delete" do
    pending "create tests"
  end

  describe "POST /juice/create" do
    pending "create tests"

    it "should return 401 page if not logged in" do
      post '/juice/create'
      expect(last_response.status).to eq 401
    end
  end

  describe "PUT juice/:id" do
    pending "create tests"
  end

  describe "DELETE juice/:id" do
    pending "create tests"
  end
end
