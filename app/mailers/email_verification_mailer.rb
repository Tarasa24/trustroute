class EmailVerificationMailer < ApplicationMailer
  default template_path: "email_identities"

  def verification_email
    @pin = params[:pin]
    mail(to: params[:email], subject: "TrustRoute Email Verification")
  end
end
