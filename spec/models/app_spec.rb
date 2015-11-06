require 'spec_helper'

describe App do
  it { should validate_presence_of(:name) }
  it { should_not allow_mass_assignment_of(:access_token) }
  it {should have_many(:devices)}
  it {should belong_to(:user)}
  
  
  it 'generates access token' do
    app = create(:app)
    app.access_token.present?.should eql(true)
  end
 
  it 'regenerates access token' do
    app = create(:app)
    previous_token = app.access_token
    app.reset_access_token
    app.save
    app.reload.access_token.should_not eql(previous_token)
  end

  it 'should not accept existing tokens' do
    app = create(:app)
    App.valid_token?(app.access_token).should eql(false)
    App.valid_token?(app.access_token, app.id).should eql(true)
  end
end

