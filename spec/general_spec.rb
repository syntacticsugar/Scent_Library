describe "General" do
  describe "/" do
    it "should serve the root page" do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to include "Sign in securely via"
      # TODO: check for something only on this page.
    end
  end

  describe "login" do
    before(:each) { visit "/" }

    describe "facebook" do
      it "should log you in" do
        click_link "Facebook"
        pending "complete test"
        expect(true).to be_false
      end
    end

    describe "twitter" do
      it "should log you in" do
        click_link "Twitter"
        pending "complete test"
        expect(true).to be_false
      end
    end
  end

  describe "404" do
    it "should return 404 page for crazy requests" do
      get '/flibberty'
      expect(last_response.status).to eq 404
    end
  end

  describe "GET /faq" do
    it "should serve the FAQ page" do
      get "/faq"
      expect(last_response).to be_ok
      expect(last_response.body).to include "Sign in securely via"
      expect(last_response.body).to include "Issue Queue"
    end
  end
end
