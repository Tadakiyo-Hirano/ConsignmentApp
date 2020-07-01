class StocksController < ApplicationController
  before_action :signed_in_user
  before_action :set_user_stocks
  # before_action :set_consignment_stocks
  before_action :signed_in_correct_user
  
  def index
    @stocks = @user.consignments.find(params[:consignment_id]).stocks
  end
  
  def new
    @stock = Stock.new
  end
  
  def create
    # @consignment = @user.consignments.find_by(id: params[:id])
    @consignment = Consignment.find(params[:consignment_id])
    @stock = @consignment.stocks.build(stock_params)
    # @consignment = @user.consignments.build(consignment_params)
    if @stock.save
      flash[:notice] = "登録完了。"
      redirect_to user_consignment_stocks_path
    else
      flash.now[:alert] = "更新に失敗しました。<br> " + @stock.errors.full_messages.join("<br>")
      render :new
    end
  end
  
  def edit
    @stock = Stock.find(params[:id])
  end
  
  def update
  end
  
  private
    
    def set_user_stocks
      @user = User.find(params[:user_id])
    end
    
    def stock_params
      params.require(:stock).permit(:processing_date, :return_quantity, :sales_quantity, :consignment_id)
    end
    
    # def set_consignment_stocks
    #   @consignment = Consignment(params[:consignment_id])
    # end
end
