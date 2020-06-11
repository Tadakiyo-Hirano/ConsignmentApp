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
  
  def customer_id_number
    Customer.find(id: object.customer_id_number).code
  end
end
