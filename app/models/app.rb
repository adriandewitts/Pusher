class App
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, type: String
  field :access_token, type: String
  field :enabled, type: Boolean   
  field :apns_certificate, type: String
  field :apns_key,         type: String
  field :apns_gateway,     type: String
  field :auth_key,         type: String  
  field :connections, type: Integer, default: 3
  
  has_many :devices
  has_many :logs
  validates :name, :access_token, presence: true
  validates :access_token, uniqueness: true
      
  before_validation :reset_access_token, on: :create
  
  attr_accessible :auth_key, :name, :type, :enabled, :user_id, :apns_certificate, :apns_key, :apns_gateway, :connections
  validates_numericality_of :connections, :greater_than => 0, :only_integer => true
  
    
  index({name: 1})
  index({access_token: 1})  
  index({_type: 1})
  index({enabled: 1})

  after_save do
    if apns_certificate_changed? || auth_key_changed?
      begin
        pusher_pid_path = Rails.root.join("tmp", "pids" ,"pusher.pid")
        pusher_pid_file = File.open(pusher_pid_path, "r")
        pusher_pid = pusher_pid_file.read().to_i

        Process.kill('INT', pusher_pid)
      rescue Exception => ex
        Airbrake.notify_or_ignore(Exception.new("Trying to restart pusher when has a new app. But got an error: #{ex.message}")) if defined?(Airbrake)
      end
    end
  end
  
  def device_count
    @device_count ||= self.devices.count
  end
  
  def self.valid_token?(token, existing_id = nil)
    app = where(access_token: token)
    app = app.where(:_id.ne => existing_id) if existing_id
    !app.exists?
  end
  
  def reset_access_token
    begin
      self.access_token = UUID.new.generate
    end while !App.valid_token?(access_token, self.id)
  end
  
end
