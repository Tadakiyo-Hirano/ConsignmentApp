class Customer < ApplicationRecord
  before_save { self.code = code.upcase }
  VALID_CODE_REGEX = /\A[\w@-]*[A-Za-z0-9][\w@-]*+\z/
  validates :code, presence: true, length: { maximum: 13 }, uniqueness: true, format: { with: VALID_CODE_REGEX }
  validates :name, presence: true, length: { maximum: 40 }
  
  # 検索
  scope :search, -> (search_params) do
    return if search_params.blank?
    name_like(search_params[:name]).code_like(search_params[:code])
  end
  scope :name_like, -> (name) { where('name LIKE ?', "%#{name}%") if name.present? }
  scope :code_like, -> (code) { where('code LIKE ?', "%#{code}%") if code.present? }
end
