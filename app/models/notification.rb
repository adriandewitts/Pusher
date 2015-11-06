class Notification
  include Mongoid::Document
  include Mongoid::Timestamps
  include Rapns::MultiJsonHelper
  include Mongoid::AutoCoords
  
  field :device, type: String
  field :devices, type: Array   
  field :payload, type: Hash  
  field :alert,   type: String

  #APNS specific fields
  field :sound, type: String, default: 'default'
  field :badge, type: Integer
  
   #GCM specific fields    
  field :delay_while_idle, type: Boolean, default: true
  field :collapse_key, type: String

  #locate devices by lng,lat  
  field :coords,  type: Array, default: []
  field :range,   type: Integer # Meters

  field :delivered, type: Boolean, default: false
  field :delivered_at, type: Time
  field :failed, type: Boolean, default: false
  field :failed_at, type: Time
  field :error_code, type: String
  field :error_description, type: String
  field :deliver_after, type: Time, default: (Time.now + 1.minutes)
   
  field :expiry, type: Integer, default: 1.day.to_i
  field :tags, type: Array, default: []
  field :retries, type: Integer, default: 1
  
  field :app_code, type: String
  field :content_available, type: Integer
  field :visible, type: Boolean

  before_validation :set_matched_devices
  
  index(coords: "2d")
  #attr_accessible :app, :deliver_after, :sound, :badge,:devices, :payload, :tags, :delay_while_idle,:collapse_key
  scope :ready_for_delivery, lambda {
      where({delivered: false,failed: false})
            .or({deliver_after:nil},
                {:deliver_after.lt => Time.now})
   }

  scope :for_apps, lambda { |apps|
    where(:app_id.in => apps.map(&:id))
  }

   def tags=(list) 
    tags = if list.is_a?(Array)
       list
     elsif list.is_a?(String)
       list.split(',').map(&:strip)
     else
       []
     end

    write_attribute :tags, tags
  end  
     
    def packed_message
      multi_json_dump(as_json)
    end

    def packed_message_size
      packed_message.bytesize
    end
   
  protected
      
    def set_matched_devices
      return true if app.blank? || !devices.blank?
      with_tags = []; in_range = []
        
      if tags.any?
        with_tags = app.devices.with_tags(tags).enabled.map(&:device)
      else
        with_tags = app.devices.enabled.map(&:device)
      end
  
      #if lat.present? && lng.present? && range.present?
      #  in_range = Log.where(app_id: app_id).not_in(device: disabled).in_range(lat, lng, range).map(&:device)
      #end
  
      self.devices = ([device] + with_tags).flatten.uniq.compact
    end    
  end
