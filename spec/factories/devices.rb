FactoryGirl.define do
  factory :device do
    app
    device { SecureRandom.hex(32) }
  end
end

