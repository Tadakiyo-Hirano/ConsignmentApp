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
  
  # Consignment.customer_id_numberから、Customer.idを引用、Custmer.idが削除されてnilの場合は削除済と表示してエラー回避
  def customer_id_number
    if Customer.where(id: object.customer_id_number).any?
      Customer.find(object.customer_id_number)
    else
      Customer.new(id: 0, code: "得意先削除済", name: "得意先削除済")
    end
  end
  
  # Consignment.product_id_numberから、Product.idを引用、Product.idが削除されてnilの場合は削除済と表示してエラー回避
  def product_id_number
    if Product.where(id: object.product_id_number).any?
      Product.find(object.product_id_number)
    else
      Product.new(id: 0, code: "商品削除済", name: "商品削除済")
    end
  end
end
