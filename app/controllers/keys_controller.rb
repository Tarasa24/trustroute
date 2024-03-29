class KeysController < ApplicationController
  before_action :load_key, only: %i[show edit dump vouch_checklist vouch_form vouch_for]
  skip_before_action :verify_authenticity_token, only: [:vouch_for]

  def new
  end

  def create
    if params[:public_key_file]
      Key.create_from_file!(params[:public_key_file])
    else
      Key.create_from_keyserver!(params[:identifier])
    end

    redirect_to new_key_session_path(identifier: params[:identifier]), notice: "Key was successfully created."
  rescue => e
    redirect_to new_key_path, alert: "Key creation failed: #{e.message} (#{e.class})"
  end

  def show
  end

  def edit
    if @key.nil? || @key != current_key
      redirect_to root_path, alert: "Key not found"
    end
  end

  def dump
    @filename = "#{@key.sha}.asc"
    @formatted_string = PGPDumpService.new(@key.keyring_entry).call
  end

  def vouch_checklist
  end

  def vouch_form
    return head :unauthorized unless current_key

    unless params[:know] == "1" && params[:trust] == "1" && params[:verify] == "1"
      redirect_to vouch_checklist_key_path(@key), alert: "You must check all boxes to vouch for a key"
    end
  end

  def vouch_for
    public_key = params[:public_key_file].read
    service = VouchService.new(current_key, @key, public_key)
    service.call
    if service.success?
      redirect_to key_path(@key), notice: "Key vouched for successfully"
    else
      redirect_to vouch_form_key_path(@key), alert: "Vouch failed: #{service.error_key}: #{service.error_message}"
    end
  end

  private

  def load_key
    @key = Key.find_by(uuid: params[:id])

    if @key.nil?
      redirect_to root_path, alert: "Key not found"
    end
  end
end
