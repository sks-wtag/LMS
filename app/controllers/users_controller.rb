# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :redirect_if_authenticated, only: %i[create new]
  before_action :authenticate_user!, only: %i[edit destroy update edit_password change_password]
  def new
    @organization = Organization.new({})
    @user = @organization.users.build({})
  end

  def destroy
    current_user.destroy
    reset_session
    redirect_to root_path, notice: 'This user account has been deleted'
  end

  def edit_password
    @user = UserViewModel.new(
      email: current_user.email,
      current_password: '',
      password: '',
      password_confirmation: '')
  end

  def change_password
    @user = current_user
    if @user.authenticate(params[:user][:current_password])
      if @user.update(
        password: params[:user][:password],
        password_confirmation: params[:user][:password_confirmation])
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
    @user.picture.purge if params[:user][:picture].present?
    if @user.update(update_params)
      redirect_to root_path, notice: 'Account updated'
    else
      flash[:error] = 'Please try again'
      render 'edit', status: :unprocessable_entity
    end
  end

  def edit
    @user = current_user
  end

  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      current_email = params[:organization][:users_attributes]["0"][:email]
      @user = @organization.users.find_by(email: current_email)
      @user.send_confirmation_email!
      redirect_to root_path, notice: 'Please check your email confirmation instructions'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def organization_params
    params.require(:organization).permit(
      :name,
      users_attributes:
        [
          :first_name,
          :last_name,
          :email,
          :phone,
          :address,
          :password,
          :password_confirmation,
          :picture
        ])
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :phone,
      :address,
      :password,
      :password_confirmation,
    )
  end

  def update_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :phone,
      :address,
      :picture)
  end
  def get_email
    params.require(:organization).permit(users_attributes:[:email])
  end

end
