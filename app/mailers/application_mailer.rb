class ApplicationMailer < ActionMailer::Base
  default from: ENV['ADMINSTRATOR_EMAIL']
  layout "mailer"
end
