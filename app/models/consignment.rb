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
    customer_name_like(search_params[:customer_name]).customer_code_like(search_params[:customer_code])
  end
  scope :customer_name_like, -> (customer_name) { where('customer_name LIKE ?', "%#{customer_name}%") if customer_name.present? }
  scope :customer_code_like, -> (customer_code) { where('customer_code LIKE ?', "%#{customer_code}%") if customer_code.present? }
end
