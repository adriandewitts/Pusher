shared_examples_for "Token Authentication" do
   describe 'token Authentication' do
    it 'denies access on missing token' do
      post :index, format: :json
      response.status.should eql(401)
      /denied/i.match(response.body).present?.should eql(true)
    end

    it 'denies access on invalid token' do
      get :index, format: :json
      response.status.should eql(401)
      /denied/i.match(response.body).present?.should eql(true)
    end

    it 'allows access on valid token' do
      app = create(:ios_app)
      get :index, format: :json, access_token: app.access_token
      response.should be_success
      /ok/.match(response.body).present?.should eql(true)
    end

    it 'sets current app' do
      app = create(:ios_app)
      get :index, format: :json, access_token: app.access_token
      assigns[:current_app].should eql(app)
    end
  end
end