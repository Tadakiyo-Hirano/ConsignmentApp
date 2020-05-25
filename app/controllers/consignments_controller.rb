class ConsignmentsController < ApplicationController
  before_action :signed_in_user
  before_action :set_user_consignments
  before_action :set_consignment, only: %i(show edit update destroy)
  before_action :signed_in_correct_user
  
  def index
  end
  
  def new
    @consignment = Consignment.new
    @test = Consignment.all.to_json
  end
  
  def create
    @consignment = @user.consignments.build(consignment_params)
    if @consignment.save
      flash[:notice] = "登録完了。"
      redirect_to @user
    else
      flash.now[:alert] = "更新に失敗しました。<br>" + @consignment.errors.full_messages.join("<br>")
      render :new
    end
  end
  
  def edit
  end
  
  def update
    ActiveRecord::Base.transaction do
      @consignment.update_attributes!(consignment_params)
      flash[:notice] = "委託情報を更新しました。"
      redirect_to @user
    end
  rescue ActiveRecord::RecordInvalid
    flash.now[:alert] = "更新に失敗しました。<br>" + @consignment.errors.full_messages.join("<br>")
    render :edit
  end
  
  def destroy
    @consignment.destroy
    flash[:alert] = "【#{@consignment.customer_info}】#{@consignment.product_info}&emsp;削除完了。"
    redirect_to @user
  end
  
  private
  
    def consignment_params
      params.require(:consignment).permit(:ship_date, :customer_info, :product_info, :serial_number, :note, :quantity, :user_id)
    end
    
    def set_user_consignments
      @user = User.find(params[:user_id])
    end
    
    def set_consignment
      unless @consignment = @user.consignments.find_by(id: params[:id])
        flash[:alert] = "アクセス権限がありません。"
        redirect_to @user
      end
    end
end
