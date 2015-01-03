describe "general" do
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

    %w[facebook twitter].each do |provider|
      describe provider do
        it "should refuse you with no credentials" do
          click_link provider.capitalize
          expect(page.html).not_to include "logged in via"

          expect(Person.all).to be_empty
        end

        it "should refuse you with bad credentials" do
          mock_auth_invalid
          click_link provider.capitalize
          expect(page.html).not_to include "logged in via"

          expect(Person.all).to be_empty
        end

        it "should log you in and create a new user" do
          mock_auth provider.to_sym
          click_link provider.capitalize
          expect(page.html).to include "logged in via #{provider.capitalize}"

          person = Person.first(name: AuthHelper::USERNAME)
          expect(person).not_to be_nil
          expect(person.nickname).to eq AuthHelper::DISPLAY_NAME
          expect(person.uid).to eq AuthHelper::UID
          expect(person.provider).to eq provider
        end
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
