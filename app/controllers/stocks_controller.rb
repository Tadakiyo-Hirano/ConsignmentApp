class StocksController < ApplicationController
  before_action :signed_in_user
  before_action :set_user
  before_action :set_user_consignment, only: %i(index new edit)
  before_action :set_consignment, only: %i(index create edit update destroy)
  before_action :set_user_consignments_stocks, only: %i(index new create edit update destroy)
  before_action :set_stock, only: %i(edit update destroy)
  before_action :signed_in_correct_user
  
  def index
    # @user_consignment = @user.consignments.find(params[:consignment_id])
    # @consignment = Consignment.find(params[:consignment_id])
    # @stocks = @user.consignments.find(params[:consignment_id]).stocks
  end
  
  def new
    # @user_consignment = @user.consignments.find(params[:consignment_id])
    # @stocks = @user.consignments.find(params[:consignment_id]).stocks
    @stock = Stock.new
  end
  
  def create
    # @consignment = Consignment.find(params[:consignment_id])
    # @stocks = @user.consignments.find(params[:consignment_id]).stocks
    @stock = @consignment.stocks.build(stock_params)
    if @stock.save
      done_decision
      flash[:notice] = "在庫受払を登録しました。"
      redirect_to user_consignment_stocks_path
    else
      flash.now[:alert] = "登録に失敗しました。<br> " + @stock.errors.full_messages.join("<br>")
      render :new
    end
  end
  
  def edit
    # @user_consignment = @user.consignments.find(params[:consignment_id])
    # @consignment = Consignment.find(params[:consignment_id])
    # @stocks = @user.consignments.find(params[:consignment_id]).stocks
  end
  
  def update
    # @consignment = Consignment.find(params[:consignment_id])
    # @stocks = @user.consignments.find(params[:consignment_id]).stocks
    ActiveRecord::Base.transaction do
      @stock.update_attributes!(stock_params)
      done_decision
      flash[:notice] = "#{@stock.processing_date}の在庫受払を更新しました。"
      redirect_to user_consignment_stocks_path
    end
  rescue ActiveRecord::RecordInvalid
    flash[:alert] = "登録に失敗しました。<br> " + @stock.errors.full_messages.join("<br>")
    render :edit
  end
  
  def destroy
    # @consignment = Consignment.find(params[:consignment_id])
    # @stocks = @user.consignments.find(params[:consignment_id]).stocks
    @stock.destroy
    done_decision
    flash[:alert] = "#{@stock.processing_date}の在庫受払を削除しました。"
    redirect_to user_consignment_stocks_url
  end
  
  private
    
    def set_user_consignments_stocks
      @stocks = @user.consignments.find(params[:consignment_id]).stocks
    end
    
    def set_user_consignment
      @user_consignment = @user.consignments.find(params[:consignment_id])
    end
    
    def set_user
      @user = User.find(params[:user_id])
    end
    
    def set_consignment
      @consignment = Consignment.find(params[:consignment_id])
    end
    
    def set_stock
      @stock = Stock.find(params[:id])
    end
    
    def stock_params
      params.require(:stock).permit(:processing_date, :return_quantity, :sales_quantity, :consignment_id)
    end
    
    def consignment_params
      params.require(:consignment).permit(:done)
    end
end
