class ProductsController < ApplicationController
  before_action :signed_in_user
  before_action :set_product, only: %i(show edit update destroy)
  
  def index
    @search_params = product_search_params
    # @search_none = @search_params.blank? || @search_params[:code] == "" && @search_params[:name] == ""
    @search_none = search_none
    @products = @search_none ? Product.search(@search_params).page(params[:page]).per(10).order(code: :asc) : 
                               Product.search(@search_params).order(code: :asc)
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
      flash.now[:alert] = "更新に失敗しました。<br>" + @product.errors.full_messages.join("<br>")
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @product.update_attributes(product_params)
      # 商品モデル(Product)を更新した場合、更新したProduct.idとProduct.product_id_numberと同じ委託(モデルconsignment)の商品コード、商品名も同時更新する。
      Consignment.where(['product_id_number == ?', @product.id]).update_all(product_code: Product.find(@product.id).code ,product_name: Product.find(@product.id).name)
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
  
  def import
    if params[:file].blank?
      flash[:alert] = "インポートするCSVファイルを選択してください。"
      redirect_to products_url
    else
      num = Product.import(params[:file])
      flash[:notice] = "#{num.to_s}件の商品情報を追加/更新しました。"
      redirect_to products_url
    end
  rescue CSV::MalformedCSVError
    flash[:alert] = "読み込みエラーが発生しました。"
    redirect_to products_url
  end
  
  private
  
    def product_params
      params.require(:product).permit(:code, :name, :classification, :category)
    end
    
    # 検索用
    def product_search_params
      params.fetch(:search, {}).permit(:code, :name)
    end
end
