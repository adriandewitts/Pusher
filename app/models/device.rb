class Device
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::AutoCoords
  
  field :device, type: String
  field :enabled, type: Boolean, default: true
  field :tags,    type: Array, default: []
    
  belongs_to :app, index: true

  alias_method :token, :device
    
  validates :device, :app, presence: true 
  
  scope :enabled, self.or({enabled: true}, {enabled: nil})
  scope :disabled, where(enabled: false)
  scope :with_tags, ->(tags){ any_in(tags: tags) }
  
  index({token: 1})
  index({enabled: 1})
  index({tags: 1})
  
  def tags=(list)
    tags = if list.is_a?(Array)
             list
           else
             list.split(',').map(&:strip)
           end
    write_attribute :tags, tags
  end
  
  def self.disable_fail_devices(from = 1.days.ago)
    devices = Apns::Feedback.where(:failed_at.gte => from).map(&:device)
    devices.uniq!
    self.in(device: devices).update_all(enabled: false) unless devices.blank?
  end

  def notifications
    app.notifications.where(:devices.in => [self.device])
  end
end
