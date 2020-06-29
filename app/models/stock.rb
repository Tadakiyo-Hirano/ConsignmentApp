class Stock < ApplicationRecord
  belongs_to :consignment
  
  validates :processing_date, presence: true
  # validates :consignment_quantity, presence: true, numericality: { greater_than: 0 }
  validates :return_quantity, presence: true, numericality: { greater_than: -1 }
  validates :sales_quantity, presence: true, numericality: { greater_than: -1 }
end
