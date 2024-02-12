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
    redirect_to root_path, notice: I18n.t('controller.users.destroy.success_notice')
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
      if params[:user][:current_password] == params[:user][:password]
        flash[:notice] = I18n.t('controller.users.change_password.change_password_notice')
      elsif @user.update(
        password: params[:user][:password],
        password_confirmation: params[:user][:password_confirmation])
        flash[:notice] = I18n.t('controller.users.change_password.success_notice')
      else
        flash[:alert] = @user.errors.full_messages.join(", ")
      end
    else
      flash[:alert] = I18n.t('errors.messages.invalid_credentials')
    end
    redirect_to user_change_password_path
  end

  def update
    @user = current_user
    error = acceptable_image(params[:user][:picture], @user)
    if params[:user][:picture].present? && error.size == 0
      @user.picture.purge
      @user.picture.attach(params[:user][:picture])
    elsif @user.errors[:picture].include?(I18n.t('controller.users.update.picture_upload_error'))
      @user.errors.delete(:picture)
    end
    if @user.update(update_params)
      redirect_to user_update_path, notice: I18n.t('controller.users.update.success_notice')
    else
      flash[:alert] = I18n.t('errors.messages.try_again')
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
      redirect_to root_path, notice: I18n.t('controller.users.create.check_email_instruction_notice')
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
      :address)
  end

  def get_email
    params.require(:organization).permit(users_attributes: [:email])
  end

  def acceptable_image(picture, record)
    unless picture.present?
      record.errors.add(:picture, I18n.t('controller.users.update.picture_upload_error'))
      return record.errors
    end
    unless File.size(picture) <= 1.megabyte
      record.errors.add(:picture, I18n.t('controller.users.update.picture_size_error'))
    end
    acceptable_types = I18n.t('controller.content.create_content.image_formats')
    unless acceptable_types.include?(picture.content_type)
      record.errors.add(:picture, I18n.t('controller.users.update.picture_format_mismatch'))
    end
    record.errors
  end
end
