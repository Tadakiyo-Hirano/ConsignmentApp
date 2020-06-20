class Consignment < ApplicationRecord
  belongs_to :user
  has_many :stocks
  
  validates :ship_date, presence: true
  validates :customer_id_number, presence: true
  validates :customer_code, presence: true, length: {maximum: 13 }
  validates :customer_name, presence: true, length: {maximum: 40 }
  validates :product_id_number, presence: true
  validates :product_code, presence: true, length: {maximum: 13 }
  validates :product_name, presence: true, length: {maximum: 40 }
  validates :serial_number, length: { maximum: 50 }
  validates :note, length: { maximum: 100 }
  validates :quantity, presence: true, numericality: { greater_than: 0 }
end
