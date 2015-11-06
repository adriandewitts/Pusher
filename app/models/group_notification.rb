require 'rapns/multi_json_helper'
class GroupNotification < Notification
  belongs_to :group, index: true
  field :notification_ids, type: Array,default: []
  after_create :create_messages  
  validates :group, :alert, presence: true 
  
  def notifications
    Notification.in(id: self.notification_ids)
  end
  
  def set_delivery!
    notification = notifications.where(delivered: true).first
    return unless notification    
    
    self.delivered_at = notification.delivered_at
    self.delivered = true
    self.save
  end
  
  
  def self.set_delivery
    self.where(delivered: false).each do |n|
      n.set_delivery!
    end
  end
  
  protected
    def set_matched_devices
      
    end
    def create_messages
      return if group && group.apps.blank?
      return if delivered
      
      self.group.apps.each do |app|          
        notitication = app.notifications.create(alert: self.alert,
                                 deliver_after: self.deliver_after,
                                 tags: self.tags)  
        self.notification_ids << notitication.id.to_s
        self.save
      end
    end
    
end