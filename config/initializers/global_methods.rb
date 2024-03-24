def redis
  @redis ||= ConnectionPool::Wrapper.new do
    Redis.new(url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0"))
  end
end

def async_redirect(path, identifier, params = {})
  if params[:flash]
    params[:flash] = render_to_string(partial: "layouts/flash", locals: {flash: params[:flash]})
  end

  ActionCable.server.broadcast "async_redirect_channel:#{identifier}",
    {
      path:,
      **params
    }
end
