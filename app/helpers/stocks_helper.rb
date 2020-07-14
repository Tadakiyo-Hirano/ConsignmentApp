module StocksHelper
  
  # 委託残数
  def stock_result(object)
    object.consignment_quantity - object.sales_quantity - object.return_quantity
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
