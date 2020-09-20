class AdminsController < ApplicationController
  before_action :authenticate_admin!
  
  def show
    @admin = Admin.find(params[:id])
  end
  
  def index
    redirect_back(fallback_location: root_path)
  end
end
