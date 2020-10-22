class CustomersController < ApplicationController
  include CustomersHelper
  
  before_action :signed_in_user, except: :import
  before_action :signed_in_admin, only: :import
  before_action :signed_in_admin, only: %i(new create edit update destroy import)
  before_action :set_customer, only: %i(update destroy)
  
  def index
    @search_params = customer_search_params
    # @customers = Customer.search(@search_params).page(params[:page]).per(10).order(code: :asc)
    @search_none = search_none
    @customers = @search_none ? Customer.search(@search_params).page(params[:page]).order(code: :asc) : 
                               Customer.search(@search_params).order(code: :asc)
    @export_customers = Customer.all
    respond_to do |format|
      format.html
      format.csv do
        if admin_signed_in? # 管理者のみCVS出力可
          send_data render_to_string.encode(Encoding::Windows_31J, undef: :replace, row_sep: "\r\n", force_quotes: true),
          filename: "得意先一覧(出力日#{DateTime.current&.strftime("%Y年%-m月%-d日%-H時%-M分")}).csv", type: :csv
        else
          redirect_to customers_url
        end
      end
    end
  end
  
  def show
  end
  
  def new
    @customer = Customer.new
  end
  
  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      flash[:notice] = "【#{@customer.code} / #{@customer.name}】を登録しました。"
      redirect_to customers_url
    else
      flash.now[:alert] = "更新に失敗しました。<br>" + @customer.errors.full_messages.join("<br>")
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @customer.update_attributes(customer_params)
      # 得意先モデル(Customer)を更新した場合、更新したCustomer.idとConsignment.customer_id_numberと同じ委託(モデルconsignment)の得意先コード、得意先名も同時更新する。
      # Consignment.where(['customer_id_number == ?', @customer.id]).update_all(customer_code: Customer.find(@customer.id).code ,customer_name: Customer.find(@customer.id).name)
      # Consignment.where(['cast(customer_id_number as integer) == ?', @customer.id]).update_all(customer_code: Customer.find(@customer.id).code ,customer_name: Customer.find(@customer.id).name) if Consignment.where(['cast(customer_id_number as integer) == ?', @customer.id]).present?
      Consignment.where('cast(customer_id_number as integer) LIKE ?', @customer.id).update_all(customer_code: Customer.find(@customer.id).code ,customer_name: Customer.find(@customer.id).name) if Consignment.where('cast(customer_id_number as integer) LIKE ?', @customer.id).present?
      flash[:notice] = "【#{@customer.code} / #{@customer.name}】の情報を更新しました。"
      redirect_to customers_url
    elsif @customer.name.blank?
      flash[:alert] = "更新に失敗しました。<br>" + @customer.errors.full_messages.join("<br>")
      redirect_to customers_url
    else
      flash[:warning] = "【#{@customer.code} / #{@customer.name}】の更新に失敗しました。<br>" + @customer.errors.full_messages.join("<br>")
      redirect_to customers_url
    end
  end
  
  def destroy
    if in_use_customer_id
      flash[:warning] = "【#{@customer.code} / #{@customer.name}】は委託情報に使用されている顧客情報です。削除できません。"
      redirect_back(fallback_location: customers_url)
    else
      @customer.destroy
      flash[:alert] = "【#{@customer.code} / #{@customer.name}】を削除しました。"
      redirect_to customers_url
    end
  end
  
  def import
    if params[:file].blank?
      flash[:alert] = "インポートするCSVファイルを選択してください。"
      redirect_to customers_url
    else
      num = Customer.import(params[:file])
      # x得意先モデル(Customer)を更新した場合、更新したCustomer.idとConsignment.customer_id_numberと同じ委託(モデルconsignment)の得意先コード、得意先名も同時更新する。
      # Customer.where.not(code: nil).each do |customer|
      # Consignment.where(['customer_id_number == ?', customer.id]).update_all(customer_code: Customer.find(customer.id).code ,customer_name: Customer.find(customer.id).name)
      # end
      flash[:notice] = "#{num.to_s}件の得意先情報を追加/更新しました。"
      redirect_to customers_url
    end
  rescue CSV::MalformedCSVError
    flash[:alert] = "読み込みエラーが発生しました。"
    redirect_to customers_url
  end
  
  private
  
    def customer_params
      params.require(:customer).permit(:code, :name)
    end
    
    # 検索用
    def customer_search_params
      params.fetch(:search, {}).permit(:code, :name)
    end
end
