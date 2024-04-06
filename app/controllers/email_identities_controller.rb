class EmailIdentitiesController < ApplicationController
  before_action :load_email_identity, only: %i[edit validate]

  def create
    ident = EmailIdentity.find_or_create_by!(key: current_key, email: params[:email])

    redirect_to edit_email_identity_path(ident)
  end

  def edit
    @identity.send_verification_email
  end

  def validate
    unless @identity.validate_email(params[:pin])
      return redirect_to edit_email_identity_path(@identity), flash: {alert: t("email_identities.validate.invalid_pin")}
    end

    redirect_to key_path(current_key), flash: {success: t("email_identities.validate.success")}
  end

  private

  def load_email_identity
    @identity = EmailIdentity.find(params[:id])

    if @identity.nil? || @identity.key != current_key || @identity.validated
      redirect_to root_path, flash: {error: t("errors.not_found")}
    end
  end
end
