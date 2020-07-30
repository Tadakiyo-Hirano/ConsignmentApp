class ConsignmentsController < ApplicationController
  before_action :signed_in_user
  before_action :set_user_consignments
  before_action :set_consignment, only: %i(show edit update destroy)
  before_action :signed_in_correct_user
  
  def index
    # redirect_to new_user_consignment_path
  end
  
  def by_customer
    @search_params = consignment_search_params
    @search_none = consignment_search_none
    @consignments = @search_none ? @user.consignments.where(done: false).order(customer_code: :asc).group_by(&:customer_id_number) : 
                                   @user.consignments.where(done: false).search(@search_params).order(customer_code: :asc).group_by(&:customer_id_number)
    # @consignments = Consignment.all.order(customer_id_number: :asc)
    # @consignments = Consignment.all.group(:customer_id_number).order(customer_id_number: :asc)
    # @consignments = Consignment.all.order(customer_id_number: :asc).group_by(&:customer_id_number)
    # @consignments = Consignment.where(done: false).order(customer_id_number: :asc).group_by(&:customer_id_number)
  end
  
  def by_product
    @search_params = consignment_search_params
    @search_none = consignment_search_none
    @consignments = @search_none ? @user.consignments.where(done: false).order(product_code: :asc).group_by(&:product_id_number) : 
                                   @user.consignments.where(done: false).search(@search_params).order(product_code: :asc).group_by(&:product_id_number)
    # @consignments = Consignment.all.order(product_id_number: :asc).group_by(&:product_id_number)
    # @consignments = Consignment.where(done: false).order(product_id_number: :asc).group_by(&:product_id_number)
  end
  
  def new
    @customers = Customer.all
    @products = Product.all
    @consignment = Consignment.new
    @consignment.stocks.build
  end
  
  def create
    @customers = Customer.all
    @products = Product.all
    @consignment = @user.consignments.build(consignment_params)
    if @consignment.save
      flash[:notice] = "登録完了。"
      redirect_to @user
    else
      flash.now[:alert] = "登録に失敗しました、赤枠内は必須です。<br>" + @consignment.errors.full_messages.join("<br>")
      render :new
    end
  rescue ActiveRecord::NotNullViolation
    flash[:alert] = "委託数量が入力されていません。"
    render :new
  end
  
  def edit
    @customers = Customer.all
    @products = Product.all
  end
  
  def update
    ActiveRecord::Base.transaction do
      @consignment.update_attributes!(consignment_params)
      done_decision
      flash[:notice] = "委託情報を更新しました。" + @consignment.done.to_s
      redirect_to @user
    end
  rescue ActiveRecord::RecordInvalid
    flash.now[:alert] = "更新に失敗しました。<br>" + @consignment.errors.full_messages.join("<br>")
    render :edit
  end
  
  def destroy
    @consignment.destroy
    flash[:alert] = "【#{@consignment.customer_code}】#{@consignment.product_code}&emsp;削除完了。"
    redirect_to @user
  end
  
  private
  
    def consignment_params
      params.require(:consignment).permit(:ship_date, :customer_id_number, :customer_code, :customer_name,
                                          :product_id_number, :product_code, :product_name, :serial_number,
                                          :quantity, :note, :user_id)
      # params.require(:consignment).permit(:ship_date, :customer_id_number, :customer_code, :customer_name,
      #                                     :product_id_number, :product_code, :product_name, :serial_number,
      #                                     :note, :user_id, stocks_attributes: [:id, :consignment_quantity, :return_quantity, :sales_quantity])
    end
    
    def set_user_consignments
      @user = User.find(params[:user_id])
    end
    
    def set_consignment
      unless @consignment = @user.consignments.find_by(id: params[:id]).decorate
        flash[:alert] = "アクセス権限がありません。"
        redirect_to @user
      end
    end
    
    # 検索用
    def consignment_search_params
      params.fetch(:search, {}).permit(:customer_code, :customer_name, :product_code, :product_name)
    end
end
