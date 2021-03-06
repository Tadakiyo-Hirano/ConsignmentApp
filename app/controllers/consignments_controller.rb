class ConsignmentsController < ApplicationController
  before_action :signed_in_user
  before_action :set_user_consignments
  before_action :authenticate_user!, only: %i(by_customer by_product)
  before_action :set_consignment, only: %i(show edit update destroy)
  before_action :signed_in_correct_user, only: %i(index show by_customer by_product new create edit update destroy)
  
  def index
    redirect_to new_user_consignment_path
  end
  
  def show
  end
  
  def by_customer
    @search_params = consignment_search_params
    @search_none = consignment_search_none
    @consignments = @search_none ? Consignment.where(done: false).order(customer_code: :asc).group_by(&:customer_id_number) : 
                                   Consignment.where(done: false).search(@search_params).order(customer_code: :asc).group_by(&:customer_id_number)
    @customers_pdf = Consignment.where(done: false).order(customer_code: :asc).group_by(&:customer_id_number)
  end
  
  def by_product
    @search_params = consignment_search_params
    @search_none = consignment_search_none
    @consignments = @search_none ? Consignment.where(done: false).order(product_code: :asc).group_by(&:product_id_number) : 
                                   Consignment.where(done: false).search(@search_params).order(product_code: :asc).group_by(&:product_id_number)
    @products_pdf = Consignment.where(done: false).order(product_code: :asc).group_by(&:product_id_number)
  end
  
  def by_user
    @search_params = consignment_search_params
    @search_none = consignment_search_none
    @consignments = @search_none ? Consignment.where(done: false).order(user_id: :asc).group_by(&:user_id) : 
                                   Consignment.where(done: false).search(@search_params).order(user_id: :asc).group_by(&:user_id)
    @users_pdf = Consignment.where(done: false).order(user_id: :asc).group_by(&:user_id)
  end
  
  def documents
    @documents = params[:text]
    @customers_pdf = Consignment.where(done: false).order(customer_code: :asc).group_by(&:customer_id_number)
    @products_pdf = Consignment.where(done: false).order(product_code: :asc).group_by(&:product_id_number)
    @users_pdf = Consignment.where(done: false).order(user_id: :asc).group_by(&:user_id)
    # @customers = @user.consignments.where(done: false).order(customer_code: :asc).group_by(&:customer_id_number) # pdf上で使用するレコードのインスタンスを作成
    respond_to do |format|
      format.html
      format.pdf do

        # pdfを新規作成。インスタンスを渡す。
        pdf = ConsignmentPdf.new(@customers_pdf, @products_pdf, @users_pdf, @documents)

        send_data pdf.render,
          filename:    "委託一覧表(#{Date.current}).pdf",
          type:        "application/pdf",
          disposition: "inline" # 画面に表示。外すとダウンロードされる。
      end
    end
  end
  
  def new
    @customers = Customer.all.order(code: :asc)
    @products = Product.all.order(code: :asc)
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
      flash.now[:alert] = "登録に失敗しました、赤枠内は必須です。<br>" + error_message
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
      flash[:notice] = "委託情報を更新しました。"
      redirect_to @user
    end
  rescue ActiveRecord::RecordInvalid
    flash.now[:alert] = "更新に失敗しました。<br>" + error_message
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
                                          :quantity, :note, :user_name, :user_id)
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
      params.fetch(:search, {}).permit(:customer_code, :customer_name, :product_code, :product_name, :user_name)
    end
end
