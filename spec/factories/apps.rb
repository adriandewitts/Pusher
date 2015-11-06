# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :app do
    sequence(:name){|n| "app #{n}"} 
    enabled true
    factory :ios_app, class: Apns::App do   
      apns_certificate 'flasjflasdf'
      apns_key 'fasdfjkasldf'
      apns_gateway 'lfjasldfjas'  
    end
    
    factory :android_app, class: Gcm::App do
      auth_key 'fjlfkasjdf' 
    end
  end
  
end
