  module Apns
    class Notification < Notification
      class MultipleAppAssignmentError < StandardError; end
        
        field :alert,   type: String
        field :sound,   type: String, default: 'default'
        field :badge, type: Integer
            
        belongs_to :app, class_name: 'Apns::App'
        
        validates_with Apns::DeviceTokenFormatValidator
        validates_with Apns::BinaryNotificationValidator
        validates_with Apns::RequiredFieldsValidator
        
        
        def as_json(options = {})            
          result = {}
          result['aps'] = {}
          result['aps']['alert'] = self.alert if self.alert
          result['aps']['badge'] = self.badge.to_i if self.badge
          #result['aps']['sound'] = "1.aiff"
          unless self.sound.blank?
            result['aps']['sound'] = self.sound
          end

          unless self.content_available.blank?
            result['aps']['content-available'] = self.content_available
          end

          if self.payload && (self.payload["noti_id"] rescue false)
            result['aps']['noti_id'] = self.payload["noti_id"]
          else
            result.merge! self.payload if self.payload
          end

          result            
        end
                    
        def to_binary(device_token, options = {})        
          [1, 0, expiry, 0, 32, device_token, packed_message_size, packed_message].pack("cNNccH*na*")
        end      
    end 
  end
