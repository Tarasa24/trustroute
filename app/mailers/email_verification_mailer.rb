class EmailVerificationMailer < ApplicationMailer
  def send(email, pin)
    @pin = pin
    mail(to: email, subject: "TrustRoute Email Verification")
  end
end
