class Rack::Attack
  throttle('req/ip', limit: 30, period: 1.minute) do |req|
    req.ip
  end
end

Rails.application.config.middleware.use Rack::Attack