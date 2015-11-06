require 'airbrake/capistrano'
require 'bundler/capistrano'
require 'appiphany/capistrano/base'
require 'appiphany/capistrano/god'
require 'appiphany/capistrano/passenger'
require 'appiphany/capistrano/nginx'
require 'appiphany/capistrano/mongoid'
require 'appiphany/capistrano/whenever'

set :stages, %w(production staging)
require 'capistrano/ext/multistage'

set :rails_root, File.expand_path(File.join(File.dirname(__FILE__), '..'))
set :application, 'pusher'
set :repository, 'git@github.com:adriandewitts/Pusher.git'
set :user, 'ubuntu'
set :branch, "master"