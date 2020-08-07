class ConsignmentPdf < Prawn::Document
  include ApplicationHelper
  include ConsignmentsHelper
  
  # customerにモデルなどのデータを渡します
  def initialize(customers)
    # superで初期設定を指定(ページサイズ、マージン等)
    super(page_size: 'A4', page_layout: :landscape)
    @customers_pdf = customers # インスタンスを受け取り。コンポーネント作成時などにレコード内のデータを使える
    font "vendor/fonts/ipaexm.ttf"
    stroke_axis if Rails.env.development? # 目盛りの表示(開発環境のみ)
    header
    table_content
    
    # text 'テストテスト'
  end
  
  def header
    y_position = cursor - 0

    # bounding_boxで記載箇所を指定して、textメソッドでテキストを記載
    bounding_box([0, 500, y_position], width: 270, height: 20) do
      font_size 10.5
      draw_text "得意先別･委託商品一覧", size: 25, at: [0, 20]
      # draw_text "#{@year_count}", at: [400, 50]
      draw_text "出力日:  #{Date.current.strftime("%Y年%-m月%-d日")}", at: [620, 20]
    end
  end
  
  def table_content
    table customer_rows do
      cells.size = 6 # 文字サイズ
      cells.padding = 3 # セルのpadding幅
      cells.borders = [:top, :bottom, :right, :left] # 表示するボーダーの向き(top, bottom, right, leftがある)
      cells.border_width = 0.1 # ボーダーの太さ

      # 個別設定
      # row(0)は0行目、row(1)は1行目、row(-1)は最後の行、row(-2)は最後から2行目を表す
      row(0).border_width = 0.5
      columns(0).align = :right
      columns(1).align = :right
      columns(2).align = :center
      columns(3).align = :right
      row(0).align = :center
      # row(-2).border_width = 1.5
      # row(-1).background_color = "cdd3e2"
      # row(-1).borders = []

      self.header     = true  # 1行目をヘッダーとするか否か
      self.row_colors = ['f5f5f5', 'ffffff'] # 列の色
      self.column_widths = [100, 100, 100, 100, 50, 80, 100, 130] # 列の幅
    end
  end
  
  def customer_rows
    arr = [["#{Consignment.human_attribute_name :customer_code}",
            "#{Consignment.human_attribute_name :customer_name}",
            "#{Consignment.human_attribute_name :product_code}",
            "#{Consignment.human_attribute_name :product_name}",
            "委託残",
            "#{User.human_attribute_name :name}",
            "#{Consignment.human_attribute_name :ship_date}",
            "#{Consignment.human_attribute_name :note}"
          ]]
    
    @customers_pdf.each do |customer_id_number, consignments|
       consignments.each do |consignment|
        arr << [Customer.find(customer_id_number).code,
                Customer.find(customer_id_number).name,
                Product.find(consignment.product_id_number).code,
                Product.find(consignment.product_id_number).name,
                consignment.quantity - consignment.stocks.map { |s| s.return_quantity }.sum - consignment.stocks.map { |s| s.sales_quantity }.sum,
                User.find(consignment.user_id).name,
                consignment.ship_date,
                consignment.note
              ]
       end
    end
    return arr
  end

    # テーブルのデータ部
    # 1年分の出力
    # @year_pdf.each do |yp, item|
    #   item.each do |i|
    #     if i.reception_day&.strftime("%Y") == @date
    #       arr << [i.reception_day&.strftime("%-m/%-d"),
    #               i.completed&.strftime("%-m/%-d"),
    #               sumi_text(i.delivery),
    #               blank_text(format_reception_number(i.reception_number)),
    #               i.customer_name,
    #               i.machine_model,
    #               i.category,
    #               i.repair_staff,
    #               i.condition,
    #               i.note,
    #               i.address,
    #               i.phone_number,
    #               i.mobile_phone_number]
    #     end
    #   end
    # end
end