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
        Trustroute.redis.with do |conn|
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
    # Verify the signature using a service
    # Then depending on the content type, either redirect to the root path
    #   or make the client redirect to the root path via action cable

    key = Key.find(params[:id])
    nonce = Trustroute.redis.with { |conn| conn.getdel("signature_challenge:#{key.uuid}") }
    signature = if request.content_type.include? "multipart/form-data" # form upload
      GPGME::Data.new params[:signature].read
    elsif request.content_type == "text/plain" # from curl or wget
      GPGME::Data.new request.body.read
    else
      raise "Unsupported content type"
    end

    service = SignatureChallengeService.new(key, nonce, signature)
    if service.call
      set_current_key(key)
    else
      flash[:notice] = "Signature verification failed."
    end
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
