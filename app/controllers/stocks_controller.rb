class StocksController < ApplicationController
  before_action :signed_in_user
  before_action :set_user_stocks
  # before_action :set_consignment_stocks
  before_action :signed_in_correct_user
  
  def index
    @stocks = @user.consignments.find(params[:consignment_id]).stocks
  end
  
  def new
  end
  
  def create
  end
  
  private
    
    def set_user_stocks
      @user = User.find(params[:user_id])
    end
    
    # def set_consignment_stocks
    #   @consignment = Consignment(params[:consignment_id])
    # end
end
