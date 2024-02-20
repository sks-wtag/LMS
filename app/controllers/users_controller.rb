# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :redirect_if_authenticated, only: %i[create new]
  before_action :authenticate_user!, only: %i[edit destroy update edit_password change_password]

  def new
    @organization = Organization.new
    @user = @organization.users.build
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
    error = acceptable_image(params[:user][:picture], @user)
    if error.size == 0
      @user.picture.purge
    end
    if error.size == 0 && @user.update(update_params)
      redirect_to user_update_path, notice: 'Account updated'
    else
      flash[:notice] = 'Please try again'
      render 'edit', status: :unprocessable_entity
    end
  end

  def edit
    @user = current_user
  end

  def create
    @organization = Organization.new(organization_params)
    error = acceptable_image(params[:organization][:users_attributes]["0"][:picture], @organization.users.first)
    if error.size == 0 && @organization.save
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
    params.require(:organization).permit(users_attributes: [:email])
  end

  def acceptable_image(picture, record)
    unless picture.present?
      record.errors.add(:picture, 'Please upload your profile picture')
      return record.errors
    end
    unless File.size(picture) <= 1.megabyte
      record.errors.add(:picture, "is too big")
    end
    acceptable_types = ['image/jpeg', 'image/png', 'image/jpg']
    unless acceptable_types.include?(picture.content_type)
      record.errors.add(:picture, 'must be a JPEG or PNG format')
    end
    record.errors
  end
end
