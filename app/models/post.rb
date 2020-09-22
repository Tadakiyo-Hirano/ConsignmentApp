class Post < ApplicationRecord
  YEAR_VALUES = 1..12
  DAY_VALUES = 1..31
  
  validates :month_day, inclusion: { in: DAY_VALUES }
  validates :month_notice, length: { maximum: 300 }
  validates :year_month, inclusion: { in: YEAR_VALUES }
  validates :year_day, inclusion: { in: DAY_VALUES }
  validates :year_notice, length: { maximum: 300 }
end
