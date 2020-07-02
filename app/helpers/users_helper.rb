module UsersHelper
  
  # 委託残数合計
  def user_consignment_remaining_count(c)
    @stocks = @user.consignments.find(params[:id]).stocks
    c.quantity - c.stocks.map { |s| s.return_quantity }.sum - c.stocks.map { |s| s.sales_quantity }.sum
  end
end
