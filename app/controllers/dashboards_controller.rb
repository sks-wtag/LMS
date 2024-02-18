class DashboardsController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!

  def index
    @page_title = I18n.t('controller.dashboards.index.dashboard_title')
  end

  def new_user
    authorize current_user, :new_user?, policy_class: DashboardPolicy
    @page_title = I18n.t('controller.dashboards.new_user.add_user_title')
    @user = User.new
  end

  def create_user
    authorize current_user, :create_user?, policy_class: DashboardPolicy
    @user = User.new(user_params)
    @organization = Organization.find(current_user.organization_id)
    @user.organization = @organization
    if @user.save
      UserMailer.send_email_to_user(@user, params[:user][:password]).deliver_now
      flash[:notice] = I18n.t('controller.dashboards.create_user.success_notice')
      redirect_to dashboard_show_user_path
    else
      render :new_user, status: :unprocessable_entity
    end
  end

  def change_status
    @user = User.find_by(id: params[:id])
    unless @user.present?
      invalid_params(redirect_path: dashboard_show_course_path)
      return
    end
    authorize @user, :change_status?, policy_class: DashboardPolicy
    if @user.present? && @user.update(status: (@user.status == 'Active' ? 'Inactive' : 'Active'))
      redirect_to dashboard_show_user_path, notice: I18n.t('controller.dashboards.change_status.success_notice')
    else
      redirect_to dashboard_show_user_path, alert: I18n.t('errors.messages.try_again')
    end
  end

  def show_user
    authorize current_user, :show_user?, policy_class: DashboardPolicy
    @users = policy_scope(User)
    @page_title = I18n.t('controller.dashboards.show_user.users_title')
  end

  def delete_user
    @user = User.find_by(id: params[:id])
    unless @user.present?
      invalid_params(redirect_path: dashboard_show_user_path)
      return
    end
    authorize @user, :delete_user?, policy_class: DashboardPolicy
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
