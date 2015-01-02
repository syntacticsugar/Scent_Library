require_relative "spec_helper.rb"

describe Juice do
  let(:app) { Sinatra::Application }
  let(:create_params) { { name: "test name", brand: "test brand" } }

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
    it "should return 401 page if not logged in" do
      post '/juice/create', create_params
      expect(last_response.status).to eq 401
    end

     it "should create perfume if logged in" do
      # TODO: Log in.
      post '/juice/create', create_params
      expect(last_response.status).to eq 401

      juice = Juice.first(name: create_params[:name])
      expect(juice).not_to be_nil
      expect(juice.brand.name).to eq create_params[:brand]
  end

  describe "PUT juice/:id" do
    pending "create tests"
  end

  describe "DELETE juice/:id" do
    pending "create tests"
  end
end
