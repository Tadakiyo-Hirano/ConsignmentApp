class ProductsController < ApplicationController
  before_action :signed_in_user
  before_action :set_product, only: %i(show edit update destroy)
  
  def index
    @products = Product.all.page(params[:page]).per(10).order(code: :asc)
  end
  
  def show
  end
  
  def new
    @product = Product.new
  end
  
  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:notice] = "【#{@product.code}】#{@product.name}&emsp;商品登録完了。"
      redirect_to products_url
    else
      flash[:alert] = "更新に失敗しました。<br>" + @product.errors.full_messages.join("<br>")
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @product.update_attributes(product_params)
      flash[:notice] = "【#{@product.code}】#{@product.name}&emsp;商品情報更新完了。"
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
    @product.destroy
    flash[:alert] = "【#{@product.code}】#{@product.name}&emsp;削除完了。"
    redirect_to products_url
  end
  
  private
  
    def product_params
      params.require(:product).permit(:code, :name, :classification, :category)
    end
end
