class Product < ApplicationRecord
  VALID_CODE_REGEX = /\A[A-Z0-9]+\z/
  validates :code, presence: true, length: { maximum: 20 }, uniqueness: true, format: { with: VALID_CODE_REGEX }
  validates :name, presence: true, length: { maximum: 30 }
  validates :classification, presence: true, length: { maximum: 15 }
  validates :category, presence: true, length: { maximum: 15 }
end
