module UsersHelper
  
  # 委託残数合計 consignment.quantityがnilの場合、計算を飛ばして表示させエラーを回避
  def total_consignment_balance(c)
    if c.quantity != nil
      @stocks = @user.consignments.find_by(params[:consignment_id]).stocks
      c.quantity - c.stocks.map { |s| s.return_quantity }.sum - c.stocks.map { |s| s.sales_quantity }.sum
    end
  end
  
  # 委託残数合計がマイナスの場合、文字色赤色にする。
  def total_consignment_balance_color(c)
    if total_consignment_balance(c) < 0
      "minus"
    end
  end
  
  # 0以外の委託残数
  def none_zero_total(c)
    total_consignment_balance(c) != 0
  end
end
