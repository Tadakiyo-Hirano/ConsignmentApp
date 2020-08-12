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
  
  # CSVインポート
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      # IDが見つかれば、レコード呼出し、見つかれなければ、新しく作成
      customer = find_by(code: row["code"]) || new 
      # CSVからデータを取得し、設定する
      customer.attributes = row.to_hash.slice(*updatable_attributes)
      customer.save
    end
  end
  
  def self.updatable_attributes
    ["code", "name"]
  end
end
