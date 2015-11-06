Airbrake.configure do |config|
  config.api_key     = CONFIG[:errbit_key]
  config.host        = CONFIG[:errbit_host]
  config.port        = 80
  config.secure      = config.port == 443   
end