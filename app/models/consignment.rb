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
  validates :user_name, presence: true
  after_validation :remove_consignment_error_messages
  
  # 委託情報登録時、不要なバリデーションの表示をさせない。
  def remove_consignment_error_messages
    errors.messages.delete(:customer_id_number)
    errors.messages.delete(:product_id_number)
    errors.messages.delete(:user_name)
  end
  
  # 検索
  scope :search, -> (search_params) do
    return if search_params.blank?
    customer_name_like(search_params[:customer_name]).product_name_like(search_params[:product_name]).user_name_like(search_params[:user_name])
  end
  scope :customer_name_like, -> (customer_name) { where('customer_name LIKE ?', "%#{customer_name}%") if customer_name.present? }
  scope :product_name_like, -> (product_name) { where('product_name LIKE ?', "%#{product_name}%") if product_name.present? }
  scope :user_name_like, -> (user_name) { where('user_name LIKE ?', "%#{user_name}%") if user_name.present? }
end
