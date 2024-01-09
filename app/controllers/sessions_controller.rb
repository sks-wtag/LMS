# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: %i[create new]

  def create
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user.present?
      if @user.unconfirmed?
        redirect_to new_confirmation_path, alert: 'Incorrect credentials'
      elsif @user.authenticate(params[:user][:password])
        login(@user)
        redirect_to root_path, notice: 'Successfully log in'
      else
        flash[:alert] = 'Incorrect credentials'
        render 'sessions/new', status: :unprocessable_entity
      end

    else
      flash[:alert] = 'Incorrect credentials'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: 'Signed out'
  end

  def new; end
end
