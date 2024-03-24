class AsyncRedirectChannel < ApplicationCable::Channel
  def subscribed
    stream_from "async_redirect_channel:#{params[:identifier]}"
  end
end
