module AuthorizationHelpers
  def post_with_auth(action, params = {})
    app = create(:ios_app)
    post action,{ format: :json, access_token: app.access_token }.merge(params)
  end
end

