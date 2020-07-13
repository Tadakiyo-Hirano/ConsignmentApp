class Stock < ApplicationRecord
  belongs_to :consignment
  
  validates :processing_date, presence: true
  validates :return_quantity, presence: true, numericality: { greater_than: -1 }
  validates :sales_quantity, presence: true, numericality: { greater_than: -1 }
  
  validate :return_or_sales_any_entry
  
  # フォームが0ではなく未入力だとエラーになるで、nil以外の場合だけ評価するようにする。
  def return_or_sales_any_entry
    unless return_quantity == nil || sales_quantity == nil
      errors[:base] << "引上げ数量か売上数量のいずれかを０以上で入力してください。" if return_quantity <= 0  && sales_quantity <= 0
    end
  end
end
