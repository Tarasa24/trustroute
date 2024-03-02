class KeysController < ApplicationController
  before_action :load_current_key, only: [:show, :edit]

  def new
  end

  def create
    if params[:public_key_file]
      Key.create_from_file!(params[:public_key_file])
    else
      Key.create_from_keyserver!(params[:identifier])
    end

    session[:identifier] = params[:identifier]
    redirect_to new_key_session_path, notice: "Key was successfully created."
  rescue => e
    redirect_to new_key_path, alert: "Key creation failed: #{e.message} (#{e.class})"
  end

  def show
    if @key.nil?
      redirect_to new_key_path, alert: "Key not found"
    end

    @identities = @key.identities.where(validated: true)
  end

  def edit
    if @key.nil? || @key != current_key
      redirect_to root_path, alert: "Key not found"
    end
  end

  private

  def load_current_key
    @key = Key.find_by(uuid: params[:id])
  end
end
