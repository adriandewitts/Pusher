class Group
  include Mongoid::Document
  field :name, type: String
  
  has_and_belongs_to_many :ios_apps, class_name: 'Apns::App', inverse_of: nil, index: true
  has_and_belongs_to_many :android_apps, class_name: 'Gcm::App', inverse_of: nil, index: true
  
  has_many :group_notifications
  
  belongs_to :user, index: true, inverse_of: :groups
  
  def apps
    ios_apps + android_apps
  end
end
