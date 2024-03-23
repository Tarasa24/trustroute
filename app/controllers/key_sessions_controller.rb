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
    nonce = redis.with { |conn| conn.getdel("signature_challenge:#{key.uuid}") }
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

    # Request to set current_key has to be initiated by the client but we can't trust the client not to tamper with the request
    # So we generate a JWT token of the key id with a short expiry and after the client redirects back to us we verify the JWT
    # and set the current_key if the JWT is valid
    jwt = JWT.encode(
      {key_id: key.id, exp: 1.minute.from_now.to_i},
      Rails.application.credentials.secret_key_base, "HS256"
    )
    async_redirect(set_key_key_sessions_path(jwt:), "signature_challenge:#{key.uuid}")
  end

  def set_key
    key_id = nil
    begin
      decoded_token = JWT.decode(params[:jwt], Rails.application.credentials.secret_key_base, "HS256")
      key_id = decoded_token.first["key_id"]
    rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
      return redirect_to new_key_session_path, alert: "Invalid JWT."
    end

    key = Key.find(key_id)
    return redirect_to new_key_session_path, alert: "Key not found." if key.nil?

    set_current_key(Key.find(key_id))
    redirect_to root_path, notice: "Key set successfully."
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
