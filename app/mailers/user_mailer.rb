class UserMailer < ActionMailer::Base
  default from: "adrian@appiphany.com.au"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.certificate_expired.subject
  #
  def filter(email)
    if Rails.env.production?
      email
    else
      'dan@appiphany.com.au'
    end
  end
  
  def certificate_expired(users, app)
    
    to_emails = users.map{|u| filter(u.email)}
    @app = app    
    mail to: to_emails,
         subject: "[Pusher] APNS Certificate of the #{app.name} will expire on #{app.certificate_expired_at.to_formatted_s(:long)}" 
  end
  
end
