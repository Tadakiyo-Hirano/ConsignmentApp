module ConsignmentsHelper
  
  # user, consignment側で使用。委託残数合計 create updateにも@stocks = @user.consignments.find(params[:consignment_id]).stocksを設定しないとvalidation時、undefined method mapのエラーが発生する。
  def consignment_remaining_count
    @user.consignments.find(params[:consignment_id]).quantity - @stocks.map { |s| s.return_quantity }.sum - @stocks.map { |s| s.sales_quantity }.sum
  end
  
  # user, consignment側で使用。委託残数合計がマイナスの場合、文字色赤色にする。
  def consignment_remaining_count_color
    if consignment_remaining_count < 0
      "minus"
    end
  end
  
  # stock側で使用。委託残数合計 consignment.quantityがnilの場合、計算を飛ばして表示させエラーを回避
  def total_consignment_balance(c)
    if c.quantity != nil
      @stocks = @user.consignments.find_by(params[:consignment_id]).stocks
      c.quantity - c.stocks.map { |s| s.return_quantity }.sum - c.stocks.map { |s| s.sales_quantity }.sum
    end
  end
  
  # stock側で使用。委託残数合計がマイナスの場合、文字色赤色にする。
  def total_consignment_balance_color(c)
    if total_consignment_balance(c) < 0
      "minus"
    end
  end
  
  # 0以外の委託残数
  def none_zero_total(c)
    total_consignment_balance(c) != 0
  end
  
  # 検索フォームが未入力の時
  def consignment_search_none
    @search_params.blank? || @search_params[:customer_name] == "" && @search_params[:product_name] == ""
  end
  
  # 検索結果の表示
  def consignment_search_results_text(search_hash)
    if @search_params[:customer_name] == "" && @search_params[:product_name] == ""
      "検索ワードを入力してください。"
    elsif params[:search].present?
      "検索結果 #{search_hash.count}件"
    end
  end
  
  def consignment_search_results_link(path)
    if @search_params[:customer_name] == "" && @search_params[:product_name] == ""
      return
    elsif params[:search].present?
      link_to "戻る", path
    end
  end
end
