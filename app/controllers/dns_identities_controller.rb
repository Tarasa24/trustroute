class DNSIdentitiesController < ApplicationController
  before_action :load_identity, only: [:edit, :validate]

  def edit
  end

  def create
    ident = DNSIdentity.find_or_create_by(domain: params[:domain], key: current_key)

    redirect_to edit_dns_identity_path(ident)
  end

  def validate
    return redirect_to edit_dns_identity_path(@identity), alert: "Verification failed" unless @identity.validate

    redirect_to key_path(current_key), notice: "Identity verified"
  end

  private

  def load_identity
    @identity = DNSIdentity.find(params[:id])

    redirect_to key_path(current_key), alert: "Identity not found" unless @identity && @identity.key == current_key
  end
end
