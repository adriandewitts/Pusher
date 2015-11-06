class AppsController < ApplicationController
  
  def ll
    if params[:lat]
      puts "-----------#{Time.now}----------------------"
      puts params.inspect
      puts "-------------------------------------------"
    end
    render text: File.read("#{Rails.root}/log/passenger.3001.log")
  end
  
  def is_alive
    begin
      n = Apns::Notification.first
      n.touch if n
      render text: (n.try(:updated_at) || 'empty')
    rescue Exception => ex
      render text: 'error', status: 500
    end
  end
end
