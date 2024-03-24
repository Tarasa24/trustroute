class KeysController < ApplicationController
  before_action :load_current_key, only: [:show, :edit, :dump]

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

  private

  def load_current_key
    @key = Key.find_by(uuid: params[:id])

    if @key.nil?
      redirect_to root_path, alert: "Key not found"
    end
  end
end
