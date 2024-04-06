class KeySessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:signature_challenge]

  def new
  end

  def create
    respond_to do |format|
      format.turbo_stream do
        @key = Key.by_query(params[:identifier]).first
        if @key.nil?
          return render turbo_stream: [
            turbo_stream.replace(:login, partial: "key_sessions/first_step"),
            turbo_stream.append(:flash, partial: "layouts/flash",
              locals: {flash: {error: t("key_sessions.create.not_found")}})
          ]
        end

        @nonce = SecureRandom.hex(16)
        redis.with do |conn|
          conn.set("signature_challenge:#{@key.uuid}", @nonce)
        end

        render partial: "key_sessions/second_step", locals: {key: @key, nonce: @nonce}
      end
      format.html do
        redirect_to new_key_session_path,
          flash: {error: t("errors.something_went_wrong")}
      end
    end
  end

  def signature_challenge
    key = Key.find(params[:id])
    nonce = redis.with { |conn| conn.getdel("signature_challenge:#{key.uuid}") }
    if nonce.nil?
      return redirect_to new_key_session_path,
        flash: {alert: t("key_sessions.signature_challenge.nonce_expired")}
    end

    signature = GPGME::Data.new(params[:signature_file]&.read || params[:signature])
    service = SignatureChallengeService.new(key, nonce, signature)
    service.call
    if service.success?
      set_current_key(key)
      redirect_to root_path, flash: {success: t("key_sessions.signature_challenge.success")}
    else
      redirect_to new_key_session_path,
        flash: {error: t("key_sessions.signature_challenge.error", error: service.error_message)}
    end
  end

  def destroy
    session.delete(:key_uuid)
    cookies.delete(:key_uuid)
    redirect_to root_path
  end

  def set_development_key
    set_current_key Key.order(:created_at).first

    redirect_to root_path, flash: {success: t("key_sessions.signature_challenge.success")}
  end
end
