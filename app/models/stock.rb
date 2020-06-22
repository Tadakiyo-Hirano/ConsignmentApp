class Stock < ApplicationRecord
  belongs_to :consignment
  
  validates :consignment_quantity, presence: true, numericality: { greater_than: 0 }
  validates :return_quantity, presence: true, numericality: { greater_than: -1 }
  validates :sales_quantity, presence: true, numericality: { greater_than: -1 }
end
