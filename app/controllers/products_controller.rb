class ProductsController < ApplicationController
  before_action :signed_in_user
  before_action :signed_in_admin, only: %i(new create edit update destroy import)
  before_action :set_product, only: %i(update destroy)
  
  def index
    @search_params = product_search_params
    @search_none = search_none
    @products = @search_none ? Product.search(@search_params).page(params[:page]).order(code: :asc) : 
                               Product.search(@search_params).order(code: :asc)
    @export_products = Product.all
    respond_to do |format|
      format.html
      format.csv do
        if admin_signed_in? # 管理者のみCVS出力可
          send_data render_to_string.encode(Encoding::Windows_31J, undef: :replace, row_sep: "\r\n", force_quotes: true),
          filename: "商品一覧(出力日#{DateTime.current&.strftime("%Y年%-m月%-d日%-H時%-M分")}).csv", type: :csv
        else
          redirect_to products_url
        end
      end
    end
  end
  
  def show
  end
  
  def new
    @product = Product.new
  end
  
  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:notice] = "【#{@product.code} / #{@product.name}】を登録しました。"
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
      # Consignment.where(['product_id_number == ?', @product.id]).update_all(product_code: Product.find(@product.id).code, product_name: Product.find(@product.id).name)
      # Consignment.where(['cast(product_id_number as text) == ?', @product.id]).update_all(product_code: Product.find(@product.id).code ,product_name: Product.find(@product.id).name) if Consignment.where(product_id_number: @product.id).present?
      Consignment.where(['CAST(product_id_number AS text) == ?', 'CAST(@product.id AS text)']).update_all(product_code: Product.find(@product.id).code, product_name: Product.find(@product.id).name) if Consignment.where(product_id_number: @product.id).present?
      flash[:notice] = "【#{@product.code} / #{@product.name}】の情報を更新しました。"
      redirect_to products_url
    elsif @product.name.blank?
      flash[:alert] = "更新に失敗しました。<br>" + @product.errors.full_messages.join("<br>")
      redirect_to products_url
    else
      flash[:alert] = "【#{@product.code} / #{@product.name}】の更新に失敗しました。<br>" + @product.errors.full_messages.join("<br>")
      redirect_to products_url
    end
  end
  
  def destroy
    if in_use_product_id
      flash[:warning] = "【#{@product.code} / #{@product.name}】は委託情報に使用されている商品情報です。削除できません。"
      redirect_back(fallback_location: products_url)
    else
      @product.destroy
      flash[:alert] = "【#{@product.code} / #{@product.name}】を削除しました。"
      redirect_to products_url
    end
  end
  
  def import
    if params[:file].blank?
      flash[:alert] = "インポートするCSVファイルを選択してください。"
      redirect_to products_url
    else
      num = Product.import(params[:file])
      # 商品モデル(Product)を更新した場合、更新したProduct.idとProduct.product_id_numberと同じ委託(モデルconsignment)の商品コード、商品名も同時更新する。
      Product.where.not(code: nil).each do |product|
        Consignment.where(['cast(product_id_number as text) == ?', product.id]).update_all(product_code: Product.find(product.id).code ,product_name: Product.find(product.id).name) if Consignment.where(product_code: Product.find(product.id).code).present?
      end
      flash[:notice] = "#{num.to_s}件の商品情報を追加/更新しました。"
      redirect_to products_url
    end
  rescue CSV::MalformedCSVError
    flash[:alert] = "読み込みエラーが発生しました。"
    redirect_to products_url
  end
  
  private
  
    def product_params
      params.require(:product).permit(:code, :name)
    end
    
    # 検索用
    def product_search_params
      params.fetch(:search, {}).permit(:code, :name)
    end
end
