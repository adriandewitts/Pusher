require 'spec_helper'

describe Device do
  it { should validate_presence_of(:device) }
  it { should validate_presence_of(:app) }
  it {should belong_to(:app)}

  it 'splits tags into array' do
    device = create(:device)
    device.tags = 'tag_a, tag_b'
    device.save
    device.reload.tags.should eql(['tag_a', 'tag_b'])
  end

  it 'accepts an array of tags' do
    device = create(:device)
    device.tags = [ 'tag_a', 'tag_b' ]
    device.save
    device.reload.tags.should eql(['tag_a', 'tag_b'])
  end
  
  context ".disable_fail_devices" do
    it "works" do
      app = create(:ios_app)
      good = create(:device, app:app, enabled: true)
      bad = create(:device, app:app, enabled: false)
      create(:feedback, device: bad.device, app:app)
      Device.disable_fail_devices
      good.reload.should be_enabled
      bad.reload.should_not be_enabled
    end
  end
end

 