class KeysController < ApplicationController
  def new
  end

  def create
    if params[:public_key_file]
      Key.create_from_file!(params[:public_key_file])
    else
      Key.create_from_keyserver!(params[:identifier])
    end

    redirect_to root_path, notice: "Key was successfully created."
  rescue => e
    redirect_to new_key_path, alert: "Key creation failed: #{e.message} (#{e.class})"
  end
end
