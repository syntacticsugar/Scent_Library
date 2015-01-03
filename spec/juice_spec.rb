describe Juice do
  let(:create_params) { { name: "test name", brand: "test brand" } }

  describe "GET /juice/:id" do
    pending "create tests"

    it "should fail with an unknown juice id" do
      mock_auth
      get '/juice/999'
      expect(last_response.status).to eq 400
    end
  end

  describe "GET /juice/:id/edit" do
    pending "create tests"
  end

  describe "GET /juice/:id/delete" do
    pending "create tests"
  end

  describe "POST /juice/create" do
    let(:route) { '/juice/create' }

    it "should return 401 page if not logged in" do
      post route, create_params
      expect(last_response.status).to eq 401
    end

    it "should fail if bad auth" do
      post route, create_params
      expect(last_response.status).to eq 400
    end

    it "should create perfume if logged in" do
      post '/juice/create', create_params
      expect(last_response).to be_ok

      juice = Person.first.juices.first
      expect(juice).not_to be_nil
      expect(juice.name).to eq create_params[:name]
      expect(juice.brand.name).to eq create_params[:brand]
    end
  end

  describe "PUT /juice/:id" do
    pending "create tests"
  end

  describe "DELETE /juice/:id" do
    pending "create tests"
  end
end
