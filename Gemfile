source 'https://rubygems.org'

gem 'rails', '3.2.12'
gem 'bcrypt-ruby'
gem "mongoid"#, git: 'https://github.com/mongoid/mongoid.git'
gem 'uuid'
gem 'airbrake', '3.0.9'
gem 'passenger', '~> 3.0.11'
gem "devise" 
gem 'fastercsv', :platform => :ruby_18
gem 'jquery-rails'
gem 'haml' 
gem 'rails_admin'#,git: 'https://github.com/sferik/rails_admin.git'
gem 'cancan'
gem 'whenever'
gem 'passenger', '~> 3.0.11'
gem 'sidekiq'
gem "kiqstand"
gem "multi_json", "~> 1.0"
gem 'net-http-persistent'
gem 'aws-sdk'
gem 'aws-ses', '~> 0.4.4', require: 'aws/ses'
gem 'thin'
#gem 'rapns', git: 'https://github.com/ileitch/rapns.git', require: false

#gem 'push-core'
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :doc do
  gem 'sdoc', git: 'git://github.com/ivanyv/sdoc.git'
end

group :development, :test do
  gem 'pry-rails'
  gem 'ruby-debug19'
  gem 'email_spec'
end

group :development do
   gem 'rb-inotify', '~> 0.9'
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'capistrano_colors'
  gem 'capistrano-appiphany', git: 'git://github.com/adriandewitts/capistrano-appiphany.git'
  gem 'highline'  
  gem 'spin'
  gem 'guard' 
  gem 'guard-spin'
  gem 'guard-bundler'
  gem 'guard-rake'
  gem 'guard-passenger'  
  gem 'libnotify'
end

group :test do
  # Pretty printed test output
  gem 'turn' , '< 0.8.3'
  gem 'database_cleaner'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'factory_girl_rails', '~> 3.0'
  gem 'mongoid-rspec'
  gem 'timecop'
  gem 'guard-rspec', '0.5.2'
  gem 'shoulda-matchers'
  gem 'simplecov'
end
