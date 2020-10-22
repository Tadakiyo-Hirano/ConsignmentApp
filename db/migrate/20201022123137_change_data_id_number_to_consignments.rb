class ChangeDataIdNumberToConsignments < ActiveRecord::Migration[6.0]
  def up
    # 環境ごとにマイグレーションを分ける
    if Rails.env.development? || Rails.env.test?
      change_column :consignments, :customer_id_number, :integer, null: false
      change_column :consignments, :product_id_number, :integer, null: false
    else Rails.env.production?
      # 本番環境はusingオプションを追加
      change_column :consignments, :customer_id_number, 'integer USING CAST(customer_id_number AS integer)', null: false
      change_column :consignments, :product_id_number, 'integer USING CAST(product_id_number AS integer)', null: false
    end
  end
  
  def down
    change_column :consignments, :customer_id_number, :integer, null: false
    change_column :consignments, :product_id_number, :integer, null: false
  end
end
