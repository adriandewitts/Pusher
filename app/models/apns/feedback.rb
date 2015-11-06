module Apns
  class Feedback 
    include Mongoid::Document
    include Mongoid::Timestamps
       
     field :device, type:String   
     field :failed_at, type: Time
   
    belongs_to :app, class_name: 'Apns::App'

    attr_accessible :device, :failed_at, :app

    validates :device,:failed_at, :presence => true

    after_create :disable_device
    
    def disable_device
	self.app.devices.where(device: self.device).update_all(enabled: false)
    end
	
  end
end
