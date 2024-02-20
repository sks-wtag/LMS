class DashboardsController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!

  def index
    @page_title = 'Dashboard'
  end

  def new_user
    authorize :dashboard, :new_user?
    @page_title = 'Dashboard -> Add User'
    @user = User.new
  end

  def create_user
    authorize :dashboard, :create_user?
    @user = User.new(user_params)
    @organization = Organization.find(current_user.organization_id)
    @user.organization = @organization
    if @user.save
      UserMailer.send_email_to_user(@user, params[:user][:password]).deliver_now
      flash[:notice] = 'Added a user successfully'
      redirect_to dashboard_show_user_path
    else
      render :new_user, status: :unprocessable_entity
    end
  end

  def change_status
    authorize :dashboard, :change_status?
    @user = User.find_by(id: params[:id])
    if @user.present? && @user.update(status: (@user.status == 'Active' ? 'Inactive' : 'Active'))
      redirect_to dashboard_show_user_path, notice: 'Status successfully updated.'
    else
      redirect_to dashboard_show_user_path, notice: 'Please try again'
    end
  end

  def show_user
    authorize :dashboard, :show_user?
    @users = policy_scope(User)
    @page_title = 'Dashboard -> Users'
  end

  def delete_user
    authorize :dashboard, :delete_user?
    @user = User.find_by(id: params[:id])
    @user.destroy
    redirect_to dashboard_show_user_path
  end

  private

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :phone,
      :address,
      :role,
      :password,
      :confirmation_password )
  end
end
