module ProductsHelper
  
  def product_name
    Product.find(@user.consignments.find(params[:consignment_id]).product_id_number).name
  end
end
