require 'spec_helper'
describe DevicesController do
  it_behaves_like 'Token Authentication' 
  describe "POST 'create'" do
    it 'creates a device' do
      post_with_auth :create, device: SecureRandom.hex(32)     
      response.should be_success 
    end
    
    it 'updates an existing device' do 
      device = create(:device, enabled: false)
      post_with_auth :create, access_token: device.app.access_token, device: device.token, enabled: true
      response.should be_success
      device.reload.enabled.should be_true
    end

    it 'saves tags' do
      device = create(:device)
      post_with_auth :create, access_token: device.app.access_token, 
                              device: device.token, tags: 'tag_a, tag_b'
      response.should be_success
      device.reload.tags.should eql(['tag_a', 'tag_b'])
    end
  end
end 
    