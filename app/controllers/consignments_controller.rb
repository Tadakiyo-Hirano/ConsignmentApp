class ConsignmentsController < ApplicationController
  before_action :signed_in_user
  before_action :set_consignment, only: %i(edit)
  before_action :set_user_consignments
  before_action :signed_in_correct_user
  
  def index
  end
  
  def new
    @consignment = Consignment.new
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
