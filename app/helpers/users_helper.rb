module UsersHelper
  
  # 委託残数合計
  def total_consignment_balance(c)
    @stocks = @user.consignments.find_by(params[:consignment_id]).stocks
    c.quantity - c.stocks.map { |s| s.return_quantity }.sum - c.stocks.map { |s| s.sales_quantity }.sum
  end
  
  # 0以外の委託残数
  def none_zero_total(c)
    total_consignment_balance(c) != 0
  end
end
