class Product < ApplicationRecord
  before_save { self.code = code.upcase }
  VALID_CODE_REGEX = /\A[\w@-]*[A-Za-z0-9][\w@-]*+\z/
  validates :code, presence: true, length: { maximum: 13 }, uniqueness: true, format: { with: VALID_CODE_REGEX }
  validates :name, presence: true, length: { maximum: 40 }
  validates :classification, presence: true, length: { maximum: 15 }
  validates :category, presence: true, length: { maximum: 15 }
end
