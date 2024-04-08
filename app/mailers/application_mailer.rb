class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("SMTP_USER_NAME", "trustroute@example.com")
  layout "mailer"
end
