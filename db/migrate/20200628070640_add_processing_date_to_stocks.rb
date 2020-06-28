class AddProcessingDateToStocks < ActiveRecord::Migration[6.0]
  def change
    add_column :stocks, :processing_date, :date
  end
end
