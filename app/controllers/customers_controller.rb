class CustomersController < ApplicationController
  before_action :signed_in_user
  before_action :set_customer, only: %i(update destroy)
  
  def index
    @customers = Customer.all.page(params[:page]).per(10).order(code: :asc)
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
      flash[:notice] = "【#{@customer.code}】#{@customer.name}&emsp;得意先情報更新完了。"
      redirect_to customers_url
    elsif @customer.name.blank?
      flash[:alert] = "更新に失敗しました。<br>" + @customer.errors.full_messages.join("<br>")
      redirect_to customers_url
    else
      flash[:alert] = "#{@customer.name}の更新に失敗しました。<br>" + @customer.errors.full_messages.join("<br>")
      redirect_to customers_url
    end
  end
  
  def destroy
    @customer.destroy
    flash[:alert] = "【#{@customer.code}】#{@customer.name}&emsp;削除完了。"
    redirect_to products_url
  end
  
  private
  
    def customer_params
      params.require(:customer).permit(:code, :name)
    end
end
