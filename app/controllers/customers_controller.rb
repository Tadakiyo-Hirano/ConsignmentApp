class CustomersController < ApplicationController
  include CustomersHelper
  
  before_action :signed_in_user
  before_action :set_customer, only: %i(update destroy)
  
  def index
    @search_params = customer_search_params
    # @customers = Customer.search(@search_params).page(params[:page]).per(10).order(code: :asc)
    @search_none = search_none
    @customers = @search_none ? Customer.search(@search_params).page(params[:page]).per(10).order(code: :asc) : 
                               Customer.search(@search_params).order(code: :asc)
  end
  
  def show
  end
  
  def new
    @customer = Customer.new
  end
  
  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      flash[:notice] = "【#{@customer.code}】#{@customer.name}&emsp;得意先登録完了。"
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
      # 得意先モデル(Customer)を更新した場合、更新したCustomer.idとConsignment.customer_id_numberと同じ委託(モデルconsignment)の得意先名も同時更新する。
      Consignment.where(['customer_id_number == ?', @customer.id]).update_all(customer_name: Customer.find(@customer.id).name)
      flash[:notice] = "【#{@customer.code}】#{@customer.name}&emsp;得意先情報更新完了。"
      redirect_to customers_url
    elsif @customer.name.blank?
      flash[:alert] = "更新に失敗しました。<br>" + @customer.errors.full_messages.join("<br>")
      redirect_to customers_url
    else
      flash[:warning] = "#{@customer.name}の更新に失敗しました。<br>" + @customer.errors.full_messages.join("<br>")
      redirect_to customers_url
    end
  end
  
  def destroy
    if in_use_customer_id
      flash[:warning] = "委託情報に使用されている顧客情報です。削除できません。"
      redirect_back(fallback_location: customers_url)
    else
      @customer.destroy
      flash[:alert] = "【#{@customer.code}】#{@customer.name}&emsp;削除完了。"
      redirect_to customers_url
    end
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
