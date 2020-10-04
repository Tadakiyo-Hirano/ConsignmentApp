module CustomersHelper
  
  def customer_name
    Customer.find(@user.consignments.find(params[:consignment_id]).customer_id_number).name
  end
  
  # 使用中の顧客idを検索
  def in_use_customer_id
    Consignment.where(customer_id_number: @customer.id).present?
  end
  
  def customer_page_title
    if admin_signed_in?
      "得意先一覧・編集"
    else
      "登録得意先一覧"
    end
  end
  
  # by_customer,by_productで使用。在庫数のリンクから、自分の在庫受払画面に遷移可能にする。
  def stock_link(consignment)
    if  consignment.user_id == current_user.id
      link_to total_consignment_balance(consignment), user_consignment_stocks_path(@user, consignment), class: "#{total_consignment_balance_color(consignment)}"
    else
      total_consignment_balance(consignment)
    end
  end
end
