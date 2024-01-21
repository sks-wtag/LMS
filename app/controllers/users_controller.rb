# frozen_string_literal: true

class UsersController < ApplicationController
  # if a user is authenticated then it will redirect to the root path
  before_action :redirect_if_authenticated, only: %i[create new]
  # if a user is authenticated then he/she can access edit destroy or update
  # action otherwise it will redirect to the login path
  before_action :authenticate_user!, only: %i[edit destroy update edit_password change_password]
  def new
    @user = User.new
  end

  def destroy
    current_user.destroy
    reset_session
    redirect_to root_path, notice: 'This user account has been deleted'
  end

  def edit_password
    # assign current object property
    # because we did not available all of user model data into view
    # this reason i made a user_view_model and assign specific property and send to view
    @user = UserViewModel.new(email: current_user.email, current_password: '', password: '', password_confirmation: '')
  end

  def change_password
    @user = current_user
    if @user.authenticate(params[:user][:current_password])
      if @user.update(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
        redirect_to root_path, notice: 'Password updated'
      else
        redirect_to change_password, status: :unprocessable_entity
      end
    else
      flash[:error] = 'Incorrect password'
      redirect_to change_password, status: :unprocessable_entity
    end
  end

  def update
    @user = current_user
    # assign current object property
    # because we did not available all of user model data into view
    # this reason i made a user_view_model and assign specific property and send to view
    @errors = []
    @errors.push('first_name can not be empty') unless user_params[:first_name].present?
    @errors.push('last_name can not be empty') unless user_params[:last_name].present?
    @errors.push('phone can not be empty') unless user_params[:phone].present?
    @errors.push('address can not be empty') unless user_params[:address].present?
    if @user.update(update_params)
      redirect_to root_path, notice: 'Account updated'
    else
      flash[:error] = 'Please try again'
      render 'edit', status: :unprocessable_entity
    end
  end

  def edit
    @user = UserViewModel.new(
      first_name: current_user.first_name,
      last_name: current_user.last_name,
      email: current_user.email,
      phone: current_user.phone,
      address: current_user.address
    )
  end

  def create
    @organization = Organization.new(name: params[:user][:organization_name])
    @user = @organization.users.new(user_params)
    @user.role = :admin
    if @organization.save && @user.save
      @user.send_confirmation_email!
      redirect_to root_path, notice: 'Please check your email confirmation instructions'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :address, :password, :password_confirmation)
  end

  def update_params
    params.require(:user).permit(:first_name, :last_name, :phone, :address)
  end
end
