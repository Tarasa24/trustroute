def redis
  @redis ||= ConnectionPool::Wrapper.new do
    Redis.new(url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0"))
  end
end

def secret_key_base
  ENV.fetch("SECRET_KEY_BASE", Rails.application.credentials.secret_key_base)
end
