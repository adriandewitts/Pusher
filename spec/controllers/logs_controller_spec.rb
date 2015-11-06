require 'spec_helper'

describe LogsController do
  it_behaves_like 'Token Authentication'
  describe "POST 'create'" do
    it 'should log device' do
      post_with_auth :create, device: SecureRandom.hex(32), lat: 44.44, lng: 44.44
      response.should be_success
      assigns[:log].persisted?.should be_true
    end

    it 'should associate log with app' do
      post_with_auth :create, device: SecureRandom.hex(32), lat: 44.44, lng: 44.44
      assigns[:log].app.present?.should be_true
    end
  end
end

 