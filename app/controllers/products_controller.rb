class ProductsController < ApplicationController
  before_action :signed_in_user
  before_action :set_product, only: %i(show edit update destroy)
  
  def new
    @product = Product.new
  end
  
  def index
    @products = Product.all.page(params[:page]).per(10)
  end
  
  def show
  end
  
  def create
  end
  
  def edit
  end
  
  def update
    if @product.update_attributes(product_params)
      flash[:notice] = "【#{@product.code}】#{@product.name}の情報を更新しました。"
      redirect_to products_url
    elsif @product.name.blank?
      flash[:alert] = "更新に失敗しました。<br>" + @product.errors.full_messages.join("<br>")
      redirect_to products_url
    else
      flash[:alert] = "#{@product.name}の更新に失敗しました。<br>" + @product.errors.full_messages.join("<br>")
      redirect_to products_url
    end
  end
  
  def destroy
  end
  
  private
  
    def product_params
      params.require(:product).permit(:code, :name, :classification, :category)
    end
end
