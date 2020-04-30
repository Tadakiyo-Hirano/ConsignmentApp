class AdminsController < ApplicationController
  before_action :signed_in_admin
  
  def show
    @admin = Admin.find(params[:id])
  end
end
