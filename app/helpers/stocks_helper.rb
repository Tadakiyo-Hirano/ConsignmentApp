module StocksHelper
  
  # 委託残数
  def stock_result(object)
    object.consignment_quantity - object.sales_quantity - object.return_quantity
  end
end
