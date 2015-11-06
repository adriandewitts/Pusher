module Apns
  class App < App    
    has_many :notifications, class_name: 'Apns::Notification'
    belongs_to :user, index: true, inverse_of: 'ios_apps'    
    validates :apns_certificate, :apns_key, :apns_gateway, :presence => true
    
    def certificate_expired_at
      @expired_at ||=  ::OpenSSL::X509::Certificate.new(self.apns_certificate).not_after rescue nil
    end
    
    def certificate_expired_at?(time = Time.now)
      self.certificate_expired_at && (self.certificate_expired_at <= time) 
    end
    
    def self.monitor_certificate_expired
      self.all.each do |app|
        next unless app.certificate_expired_at        
        if app.certificate_expired_at?(Time.now + 7.days) && (Time.now < app.certificate_expired_at)
         users = User.admin.all        
         UserMailer.certificate_expired(users, app).deliver 
        end
      end
    end
  end
end
 
