def redis
  @redis ||= ConnectionPool::Wrapper.new do
    Redis.new(url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0"))
  end
end
