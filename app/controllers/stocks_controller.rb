class StocksController < ApplicationController
  before_action :signed_in_user
  before_action :set_user_stocks
  before_action :set_stock, only: %i(edit update destroy)
  # before_action :set_consignment_stocks
  before_action :signed_in_correct_user
  
  def index
    @stocks = @user.consignments.find(params[:consignment_id]).stocks
  end
  
  def new
    @stocks = @user.consignments.find(params[:consignment_id]).stocks # befor actionに設定する
    @stock = Stock.new
  end
  
  def create
    @consignment = Consignment.find(params[:consignment_id])
    @stocks = @user.consignments.find(params[:consignment_id]).stocks # befor actionに設定する
    @stock = @consignment.stocks.build(stock_params)
    if @stock.save
      # unless none_zero_total(@consignment)
        # @consignment.done = true
        @consignment.update_attribute(:done, true)
      # end
      # @aaa = @consignment.quantity - @consignment.stocks.map { |s| s.return_quantity }.sum - @consignment.stocks.map { |s| s.sales_quantity }.sum
      
      flash[:notice] = "登録完了。" + @consignment.done.to_s
      redirect_to user_consignment_stocks_path
    else
      flash.now[:alert] = "登録に失敗しました。<br> " + @stock.errors.full_messages.join("<br>")
      render :new
    end
  end
  
  def edit
    @stocks = @user.consignments.find(params[:consignment_id]).stocks # befor actionに設定する
  end
  
  def update
    @stocks = @user.consignments.find(params[:consignment_id]).stocks # befor actionに設定する
    ActiveRecord::Base.transaction do
      @stock.update_attributes!(stock_params)
      flash[:notice] = "更新"
      redirect_to user_consignment_stocks_path
    end
  rescue ActiveRecord::RecordInvalid
    flash[:alert] = "失敗"
    render :edit
  end
  
  def destroy
    @stock.destroy
    flash[:alert] = "#{@stock.processing_date}の在庫受払データを削除しました。"
    redirect_to user_consignment_stocks_url
  end
  
  private
    
    def set_user_stocks
      @user = User.find(params[:user_id])
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
    
    # def set_consignment_stocks
    #   @consignment = Consignment(params[:consignment_id])
    # end
end
