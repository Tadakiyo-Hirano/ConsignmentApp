class Post < ApplicationRecord
  YEAR_VALUES = 1..12
  DAY_VALUES = 1..31
  
  validates :month_day, inclusion: { in: DAY_VALUES }
  validates :month_notice, length: { maximum: 300 }
  validates :year_month, inclusion: { in: YEAR_VALUES }
  validates :year_day, inclusion: { in: DAY_VALUES }
  validates :year_notice, length: { maximum: 300 }
  validate :month_end_judg
  
  def month_end_judg
    m = year_month
    d = year_day
    if m == 2 && d == 30 || m == 2 && d ==31
      errors.add(:year_day, "の内容が不正です")
    elsif m == 4 && d == 31 || m == 6 && d == 31 || m == 9 && d == 31 || m == 11 && d == 31
      errors.add(:year_day, "の内容が不正です")
    end
  end
end
