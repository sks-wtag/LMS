# frozen_string_literal: true

class UserViewModel
  attr_accessor :first_name, :last_name, :email, :phone, :address, :password, :password_confirmation, :current_password
  def initialize(first_name: nil, last_name: nil, email: nil, phone: nil, address: nil, password: nil, password_confirmation: nil, current_password: nil)
    @first_name = first_name
    @last_name = last_name
    @email = email
    @phone = phone
    @address = address
    @password = password
    @password_confirmation = password_confirmation
    @current_password = current_password
    @errors = {}
  end
end
