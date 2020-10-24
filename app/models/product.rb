class Product < ApplicationRecord
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
    imported_num = 0

    open(file.path, 'r:cp932:utf-8', undef: :replace) do |f|
      csv = CSV.new(f, :headers => :first_row)
      begin
        csv.each do |row|
          next if row.header_row?
          table = Hash[[row.headers, row.fields].transpose]

          product = find_by(code: table["code"])
          if product.nil?
            product = new
          end

          product.attributes = table.to_hash.slice(*table.to_hash.except(:code).keys)

          if product.valid?
            product.save!
            imported_num += 1
          end
        end
      rescue
      end
    end
    imported_num
  end
  
  #mac,windowsで文字コードエラーが解決しないため上記に変更
  # def self.import(file)
  #   imported_num = 0
  #   CSV.foreach(file.path, headers: true, encoding: 'r:CP932') do |row|
  #     # IDが見つかれば、レコード呼出し、見つかれなければ、新しく作成
  #     product = find_by(code: row["code"]) || new 
  #     # CSVからデータを取得し、設定する
  #     product.attributes = row.to_hash.slice(*updatable_attributes)
  #     product.save
  #     imported_num += 1
  #   end
  #   imported_num
  # end
  
  # def self.updatable_attributes
  #   ["code", "name"]
  # end
end
