module UsersHelper
  
  # Customer.idからConsignmet.cuttomer_code,nameを表示
  def customer_code(id)
    Customer.find(id).code
  end
  
  def customer_name(id)
    Customer.find(id).name
  end
  
  # Product.idからConsignmet.product_code,nameを表示
  def product_code(id)
    Product.find(id).code
  end
  
  def product_name(id)
    Product.find(id).name
  end
end
