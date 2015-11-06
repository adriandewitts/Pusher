module Gcm
  class App < App    
    validates :auth_key, :presence => true
    has_many :notifications, class_name: 'Gcm::Notification'
    belongs_to :user, index: true, inverse_of: 'android_apps'
  end
end
