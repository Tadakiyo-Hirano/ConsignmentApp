module CustomersHelper
  
  def customer_name
    Customer.find(@user.consignments.find(params[:consignment_id]).customer_id_number).name
  end
  
  # 使用中の顧客idを検索
  def in_use_customer_id
    Consignment.where(customer_id_number: @customer.id).present?
  end
end
