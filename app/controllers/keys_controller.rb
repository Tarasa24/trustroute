class KeysController < ApplicationController
  before_action :load_key, only: %i[show edit dump vouch_checklist vouch_form vouch_for revoke destroy]
  before_action :set_breadcrumbs, only: %i[show new edit dump revoke vouch_checklist vouch_form]

  def new
  end

  def create
    key = if params[:public_key_file]
      Key.create_from_file!(params[:public_key_file])
    else
      Key.create_from_keyserver!(params[:identifier])
    end

    redirect_to new_key_session_path(identifier: key.keyid),
      flash: {success: t("keys.create.success")}
  rescue => e
    redirect_to new_key_path,
      flash: {error: t("keys.create.error", error: e.message)}
  end

  def show
    @name_aliases = @key.aliases&.uniq(&:name)&.filter { |uid| uid.name != @key.name }
  end

  def edit
    if @key.nil? || @key != current_key
      redirect_to root_path, flash: {errror: t("errors.not_found")}
    end
  end

  def dump
    respond_to do |format|
      format.html do
        @filename = "#{@key.sha}.asc"
        @formatted_string = PGPDumpService.new(@key.keyring_entry).call

        render "dump"
      end

      format.asc do
        data = @key.keyring_entry.export(armor: true)
        send_data data, filename: @key.sha + ".asc"
      end
    end
  end

  def vouch_checklist
  end

  def vouch_form
    return head :unauthorized unless current_key

    unless params[:know] == "1" && params[:trust] == "1" && params[:verify] == "1"
      redirect_to vouch_checklist_key_path(@key),
        flash: {alert: t("keys.vouch_form.checklist_incomplete")}
    end
  end

  def vouch_for
    public_key = params[:public_key_file]&.read || params[:public_key]
    service = VouchService.new(current_key, @key, public_key)
    service.call
    if service.success?
      redirect_to key_path(@key),
        flash: {success: t("keys.vouch_for.success")}
    else
      redirect_to vouch_form_key_path(@key, know: "1", trust: "1", verify: "1"),
        flash: {error: t("keys.vouch_for.error", error: service.error_message)}
    end
  end

  def revoke
  end

  def destroy
    if @key != current_key
      redirect_to root_path, flash: {error: t("errors.not_found")}
    end

    signature = params[:signature_file]&.read || params[:signature]
    service = RevokeService.new(@key, GPGME::Data.new(signature))
    service.call

    if service.success?
      redirect_to root_path, flash: {success: t("keys.destroy.success")}
    else
      redirect_to key_path(@key), flash: {error: t("keys.destroy.error", error: service.error_message)}
    end
  end

  private

  def load_key
    @key = Key.find_by(uuid: params[:id])

    redirect_to root_path, flash: {error: t("errors.not_found")} if @key.nil?

    unless @key.valid?
      redirect_to root_path, flash: {error: t("errors.something_went_wrong", error: @key.errors.full_messages.join(", "))}
    end
  end

  def set_breadcrumbs
    return add_breadcrumb t(".breadcrumb"), new_key_path if @key.nil?

    add_breadcrumb @key.sha, key_path(@key)
    return if action_name == "show"

    add_breadcrumb t(".breadcrumb"), url_for(action: action_name, id: @key.uuid)
  end
end
