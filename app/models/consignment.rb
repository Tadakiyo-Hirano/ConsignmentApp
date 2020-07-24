class Consignment < ApplicationRecord
  belongs_to :user
  has_many :stocks, dependent: :destroy
  accepts_nested_attributes_for :stocks
  
  validates :ship_date, presence: true
  validates :customer_id_number, presence: true
  validates :customer_code, presence: true, length: {maximum: 13 }
  validates :customer_name, presence: true, length: {maximum: 40 }
  validates :product_id_number, presence: true
  validates :product_code, presence: true, length: {maximum: 13 }
  validates :product_name, presence: true, length: {maximum: 40 }
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :serial_number, length: { maximum: 50 }
  validates :note, length: { maximum: 100 }
  
  # 検索
  scope :search, -> (search_params) do
    return if search_params.blank?
    customer_like(search_params[Customer.find([:customer_id_number]).name]).product_like(search_params[Product.find([:product_id_number]).name])
  end
  scope :customer_like, -> (customer) { where('name LIKE ?', "%#{customer}%") if customer.present? }
  scope :product_like, -> (product) { where('code LIKE ?', "%#{product}%") if product.present? }
end
