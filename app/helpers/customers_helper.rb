module CustomersHelper
  
  # 使用中の顧客idを検索
  def in_use_customer_id
    Consignment.where(customer_id_number: @customer.id).present?
  end
end
