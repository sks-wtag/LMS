Rack::Attack.throttled_responder = ->(env) {
  [
    403,
    { 'Content-Type' => 'application/json' },
    [{ error: 'Retry later', message: I18n.t('errors.messages.blocking_email_notice') }.to_json]
  ]
}
Rails.application.config.middleware.use Rack::Attack
