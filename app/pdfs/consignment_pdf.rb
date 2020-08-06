class ConsignmentPdf < Prawn::Document
  include ApplicationHelper
  
  # customerにモデルなどのデータを渡します
  def initialize(customers)
    # superで初期設定を指定(ページサイズ、マージン等)
    super(page_size: 'A4', page_layout: :landscape)
    @customers_pdf = customers # インスタンスを受け取り。コンポーネント作成時などにレコード内のデータを使える
    font "vendor/fonts/ipaexm.ttf"
    stroke_axis if Rails.env.development? # 目盛りの表示(開発環境のみ)
    # header
    # table_content
    
    text 'テストテスト'
  end
end