class Log
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::AutoCoords
  belongs_to :app

  field :device, type: String
  field :coords, type: Array
  
  index(coords: '2d')
  validates :app_id, presence: true
 
  attr_accessible :device, :lat, :lng, :coords

  scope :in_range, lambda { |lat, lng, range|
    where(:coords.near(:sphere) => { point: { lat: lat, lng: lng }, max: range, unit: :m })
  }
end

