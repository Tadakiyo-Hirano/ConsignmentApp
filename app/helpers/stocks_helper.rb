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
  
  # 委託残数合計 create updateにも@stocks = @user.consignments.find(params[:consignment_id]).stocksを設定しないとvalidation時、undefined method mapのエラーが発生する。
  def consignment_remaining_count
    @user.consignments.find(params[:consignment_id]).quantity - @stocks.map { |s| s.return_quantity }.sum - @stocks.map { |s| s.sales_quantity }.sum
  end
  
  # 委託タスク完了判定 委託残数0の時、done: trueにする。
  def done_decision
    unless none_zero_total(@consignment)
      @consignment.update_attribute(:done, true)
    else
      @consignment.update_attribute(:done, false)
    end
  end
end
