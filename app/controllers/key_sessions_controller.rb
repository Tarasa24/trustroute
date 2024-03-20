class KeySessionsController < ApplicationController
  def new
  end

  def create
    respond_to do |format|
      format.turbo_stream do
        @key = Key.by_query(params[:identifier]).first
        if @key.nil?
          return render turbo_stream: [
            turbo_stream.replace(:login, partial: "key_sessions/first_step"),
            turbo_stream.append(:flash, partial: "layouts/flash", locals: {flash: {notice: "Key not found."}})
          ]
        end

        @nonce = SecureRandom.hex(16)
        session[:nonce] = @nonce

        render partial: "key_sessions/second_step", locals: {key: @key, nonce: @nonce}
      end
      format.html do
        redirect_to new_key_session_path, notice: "Something went wrong. Please try again."
      end
    end

    # set_current_key(@key)
  end

  def signature_challenge
  end

  def destroy
    session.delete(:key_uuid)
    cookies.delete(:key_uuid)
    redirect_to root_path
  end

  def set_development_key
    set_current_key(Key.first)

    redirect_to root_path
  end
end
