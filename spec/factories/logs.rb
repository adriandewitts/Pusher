FactoryGirl.define do
  factory :log do
    app
    device SecureRandom.hex(32)
    coords { { lat: rand(-90...90.0), lng: rand(-180...180) } }
  end
end

