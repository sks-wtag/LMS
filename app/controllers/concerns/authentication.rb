module Authentication
  extend ActiveSupport::Concern
  include AuthenticationHelper
  included do
    before_action :current_user
    helper_method :current_user
    helper_method :user_signed_in
  end
end
