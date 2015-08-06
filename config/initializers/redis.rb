REDIS_URL = "redis://#{ENV['REDIS_PORT_6379_TCP_ADDR'].presence || '127.0.0.1'}:6379"

Sidekiq.configure_client do |config|
  config.redis = { url: REDIS_URL }
end

Sidekiq.configure_server do |config|
  config.redis = { url: REDIS_URL }
end
