class ConsignmentsController < ApplicationController
  before_action :set_user
  
  def index
  end
  
  def new
    @consignment = Consignment.new
  end
  
  def create
    @user = Consignment.new(consignment_params)
    # if @consignment.save
      flash[:notice] = "登録完了。"
      redirect_to user_url
    # else
    #   flash.now[:alert] = "更新に失敗しました。"
    #   render :new
    # end
  end
  
  private
  
    def consignment_params
      params.require(:user).permit(consignments: [:ship_date, :customer_info, :product_info, :serial_number, :note, :quantity])[:consignments]
    end
end
