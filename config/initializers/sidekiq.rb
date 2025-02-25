url = Rails.env.development? ? 'localhost' : 'redis5.locum.ru'
Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{url}:6379" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{url}:6379" }
end
