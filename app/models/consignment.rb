class Consignment < ApplicationRecord
  belongs_to :user
  
  validates :ship_date, presence: true
  validates :customer_id_number, presence: true
  validates :customer_info, presence: true
  validates :customer_name, presence: true
  validates :product_info, presence: true
  validates :serial_number, length: { maximum: 50 }
  validates :note, length: { maximum: 100 }
  validates :quantity, presence: true, numericality: { greater_than: 0 }
end
