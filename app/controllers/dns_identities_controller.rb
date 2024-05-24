class DNSIdentitiesController < ApplicationController
  before_action :load_identity, only: [:edit, :validate]
  before_action :set_breadcrumbs, only: %i[edit]

  def edit
  end

  def create
    ident = DNSIdentity.find_or_create_by(domain: params[:domain], key: current_key)

    redirect_to edit_dns_identity_path(ident)
  end

  def validate
    unless @identity.validate
      return redirect_to edit_dns_identity_path(@identity),
        flash: {error: t("dns_identities.validate.validation_fail")}
    end

    redirect_to key_path(current_key),
      flash: {success: t("dns_identities.validate.validation_success")}
  end

  private

  def load_identity
    @identity = DNSIdentity.find(params[:id])

    unless @identity && @identity.key == current_key
      redirect_to key_path(current_key), flash: {error: t("errors.not_found")}
    end

    if @identity.validated?
      redirect_to key_path(current_key),
        flash: {notice: t("dns_identities.load_identity.already_validated")}
    end
  end

  def set_breadcrumbs
    add_breadcrumb @identity.key.sha, key_path(@identity.key)
    add_breadcrumb t("keys.edit.breadcrumb"), edit_key_path(@identity.key)

    add_breadcrumb t(".breadcrumb"), edit_dns_identity_path(@identity)
  end
end
