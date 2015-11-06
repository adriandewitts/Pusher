# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification, class: Apns::Notification do
    association :app, factory: :ios_app
  end
end
