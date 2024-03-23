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
            turbo_stream.append(:flash, partial: "layouts/flash", locals: {flash: {notice: "Key not found."}})
          ]
        end

        @nonce = SecureRandom.hex(16)
        redis.with do |conn|
          conn.set("signature_challenge:#{@key.uuid}", @nonce)
        end

        render partial: "key_sessions/second_step", locals: {key: @key, nonce: @nonce}
      end
      format.html do
        redirect_to new_key_session_path, notice: "Something went wrong. Please try again."
      end
    end
  end

  def signature_challenge
    key = Key.find(params[:id])
    nonce = redis.with { |conn| conn.get("signature_challenge:#{key.uuid}") }
    signature = if request.content_type.include? "multipart/form-data" # form upload
      GPGME::Data.new params[:signature].read
    elsif request.content_type == "text/plain" # from curl or wget
      GPGME::Data.new request.body.read
    else
      raise "Unsupported content type"
    end

    service = SignatureChallengeService.new(key, nonce, signature)
    service.call
    unless service.success?
      return async_redirect(
        new_key_session_path, "signature_challenge:#{key.uuid}", flash: {alert: service.error_message}
      )
    end

    set_current_key(key)
    redis.with { |conn| conn.del("signature_challenge:#{key.uuid}") }
    async_redirect(root_path, "signature_challenge:#{key.uuid}", flash: {notice: "Successfully signed in."})
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
