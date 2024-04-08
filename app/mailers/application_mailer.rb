class ApplicationMailer < ActionMailer::Base
  default from: "#{ENV.fetch("SMTP_USER_NAME", "trustroute")}@#{ENV.fetch("SMTP_DOMAIN", "example.com")}"
  layout "mailer"
end
