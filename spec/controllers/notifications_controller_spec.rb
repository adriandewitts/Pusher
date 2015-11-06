require 'spec_helper'

describe NotificationsController do 
  it_behaves_like 'Token Authentication'
  describe "POST 'create'" do
    it 'should create a push notification' do
      post_with_auth :create, device: SecureRandom.hex(32)
      assigns[:notification].persisted?.should be_true
    end  
   
    it 'saves tags' do
      app = create(:ios_app)
      create(:device, tags: ['tag_a','tag_c'], app: app)
      controller.should_receive(:current_app).at_least(1).and_return(app)           
      post_with_auth :create, tags: 'tag_a, tag_b'
      response.should be_success
      Notification.last.tags.should eql(['tag_a', 'tag_b'])
    end
  end  
 
  describe "GET 'show'" do
    it 'should return the notification' do
      notification = create(:notification, devices: [SecureRandom.hex(32)])
      get :show, id: notification.id, format: 'json', access_token: notification.app.access_token
      response.should be_success
      assigns[:notification].id.should eql(notification.id)
    end

    it 'should not return a notification for another app' do
      app = create(:ios_app)
      notification = create(:notification, devices: [SecureRandom.hex(32)])
      lambda {
        get :show, id: notification.id, format: 'json', access_token: app.access_token
      }.should raise_error(Mongoid::Errors::DocumentNotFound)
    end
  end
end

