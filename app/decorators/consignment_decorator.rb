class ConsignmentDecorator < Draper::Decorator
  delegate_all
  decorates_association :user

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
  
  # Consignment.customer_id_numberから、Customer.idを引用
  def customer_id_number
    Customer.find(object.customer_id_number)
  end
  
  # Consignment.product_id_numberから、Product.idを引用
  def product_id_number
    Product.find(object.product_id_number)
  end
end
