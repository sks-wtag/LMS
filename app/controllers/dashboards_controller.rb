class DashboardsController < ApplicationController
  layout 'dashboard'
  # if a user is authenticated then he/she can access edit destroy or update
  # action otherwise it will redirect to the login path
  before_action :authenticate_user!
  def index
    @page_title = 'Dashboard'
  end

  def new_user
    @page_title = 'Dashboard -> Add User'
    @user = User.new({})
  end

  def create_user
    @user = User.new(user_params)
    @organization = Organization.find(current_user.organization_id)
    @user.organization = @organization
    if @user.save
      flash[:notice] = 'Added a user successfully'
      redirect_to root_path
    else
      render :new_user, status: :unprocessable_entity
    end
  end

  def show_user
    @page_title = 'Dashboard -> Users'
    @users = User.where(organization_id: current_user.organization_id)
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :address, :password, :confirmation_password)
  end

end
