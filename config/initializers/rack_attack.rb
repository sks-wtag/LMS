class Rack::Attack
  throttle('req/login', limit: 10, period: 5.minute) do |req|
    if req.path == '/login' && req.post?
      req.params["user"]["email"].to_s.downcase.gsub(/\s+/, "").presence
    end
  end
end
Rails.application.config.middleware.use Rack::Attack
