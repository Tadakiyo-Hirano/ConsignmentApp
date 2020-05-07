class ProductsController < ApplicationController
  before_action :signed_in_user
  before_action :set_product, only: %i(show create update destroy)
  
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
  
  def update
  end
  
  def destroy
  end
end
