class ConsignmentsController < ApplicationController
  
  def index
    @user = User.find(params[:id])
  end
  
  def new
  end
end
