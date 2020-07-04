class StockDecorator < ApplicationDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
  
  # def consignment_quantity
  #   object.stocks.each do |aa|
  #     aa
  #   end
  # end
  
  def return_quantity
    stock.return_quantity if 0 != stock.return_quantity
  end
  
  def sales_quantity
    stock.sales_quantity if 0 != stock.sales_quantity
  end
end
