class Product < ApplicationRecord
  validates :code, presence: true, length: { maximum: 20 }, uniqueness: true
  validates :name, presence: true, length: { maximum: 30 }
  validates :classification, presence: true, length: { maximum: 15 }
  validates :category, presence: true, length: { maximum: 15 }
end
