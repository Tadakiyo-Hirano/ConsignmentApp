class AdminsController < ApplicationController
  before_action :authenticate_admin!
  
  def show
    @admin = Admin.find(params[:id])
  end
  
  def users_index
    @users = User.all
  end
end
