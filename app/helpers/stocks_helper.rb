module StocksHelper
  
  # 委託残数
  def stock_result(object)
    object.consignment_quantity - object.sales_quantity - object.return_quantity
  end
  
  def customer_name
    Customer.find(@user.consignments.find(params[:consignment_id]).customer_id_number).name
  end
  
  def product_name
    Product.find(@user.consignments.find(params[:consignment_id]).product_id_number).name
  end
end
