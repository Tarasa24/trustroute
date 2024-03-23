def redis
  @redis ||= ConnectionPool::Wrapper.new do
    Redis.new(url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0"))
  end
end

def async_redirect(path, identifier)
  NChannel.broadcast_to(
    identifier,
    head: 302, # redirection code, just to make it clear what you're doing
    path: path # you'll need to use url_helpers, so include them in your file
  )
end
