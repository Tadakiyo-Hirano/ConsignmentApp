module ProductsHelper
  
  def product_name
    Product.find(@user.consignments.find(params[:consignment_id]).product_id_number).name
  end
  
  # 使用中の商品idを検索
  def in_use_product_id
    Consignment.where(product_id_number: @product.id).present?
  end
  
  def product_page_title
    if admin_signed_in?
      "商品一覧・編集"
    else
      "登録商品一覧"
    end
  end
end
