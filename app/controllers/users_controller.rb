# frozen_string_literal: true

class UsersController < ApplicationController
  
  before_action :redirect_if_authenticated, only: %i[create new]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_confirmation_email!
      redirect_to root_path, notice: 'Please check your email confirmation instructions'
    else
      render :new, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :address, :password, :password_confirmation)
  end
end
