# frozen_string_literal: true

class UserViewModel
  attr_accessor :first_name, :last_name, :email, :phone, :password, :password_confirmation, :current_password

  def initialize(attributes = {})
    @first_name = attributes[:first_name]
    @last_name = attributes[:last_name]
    @email = attributes[:email]
    @phone = attributes[:phone]
    @password = attributes[:password]
    @password_confirmation = attributes[:password_confirmation]
    @current_password = attributes[:current_password]
  end
end
