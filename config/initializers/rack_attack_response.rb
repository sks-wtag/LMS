Rack::Attack.throttled_responder = ->(env) {
  [
    403,
    { 'Content-Type' => 'application/json' },
    [{ error: 'Retry later', message: "You've reached the maximum login attempts. Please try again later." }.to_json]
  ]
}
Rails.application.config.middleware.use Rack::Attack
