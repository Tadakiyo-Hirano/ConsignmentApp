class ConsignmentPdf < Prawn::Document
  include ApplicationHelper
  include ConsignmentsHelper
  
  # 引数にモデルなどのデータを渡す
  def initialize(customers, products, users, documents)
    super(page_size: 'A4', page_layout: :landscape) # superで初期設定を指定(ページサイズ、マージン等)
    @documents = documents
    @customers_pdf = customers # インスタンスを受け取り。コンポーネント作成時などにレコード内のデータを使える
    @products_pdf = products
    @users_pdf = users
    font "vendor/fonts/ipaexm.ttf"
    stroke_axis if Rails.env.development? # 目盛りの表示(開発環境のみ)
    
    if @documents == "customers_pdf" || @documents == "products_pdf" || @documents == "users_pdf"
      header
      table_content
    else
      text "表示エラーです。ページを閉じてください。", size: 25
    end
  end
  
  def header
    y_position = cursor - 0

    # bounding_boxで記載箇所を指定して、textメソッドでテキストを記載
    bounding_box([0, 500, y_position], width: 270, height: 20) do
      font_size 10.5
      
      if @documents == "customers_pdf"
        draw_text "得意先別･委託商品一覧", size: 25, at: [0, 20]
      elsif @documents == "products_pdf"
        draw_text "商品別･委託商品一覧", size: 25, at: [0, 20]
      elsif @documents == "users_pdf"
        draw_text "担当者別別･委託商品一覧", size: 25, at: [0, 20]
      end
      
      draw_text "出力日:  #{Date.current.strftime("%Y年%-m月%-d日")}", at: [620, 20]
    end
  end
  
  def table_content
    table consignment_rows do
      cells.size = 6 # 文字サイズ
      cells.padding = 3 # セルのpadding幅
      cells.borders = [:top, :bottom, :right, :left] # 表示するボーダーの向き(top, bottom, right, leftがある)
      cells.border_width = 0.1 # ボーダーの太さ

      # 個別設定
      # row(0)は0行目、row(1)は1行目、row(-1)は最後の行、row(-2)は最後から2行目を表す
      row(0).border_width = 0.5
      columns(0).align = :center
      columns(1).align = :center
      columns(2).align = :center
      columns(3).align = :center
      columns(4).align = :center
      columns(5).align = :center
      columns(6).align = :center
      columns(7).align = :center
      columns(8).align = :center
      row(0).align = :center
      # row(-2).border_width = 1.5
      # row(-1).background_color = "cdd3e2"
      # row(-1).borders = []

      self.header     = true  # 1行目をヘッダーとするか否か
      self.row_colors = ['ffffff'] # 列の色
      if @documents == "customers_pdf" || @documents == "products_pdf"
        self.column_widths = [60, 100, 60, 100, 40, 50, 60, 100, 190] # 列の幅
      else
        self.column_widths = [50, 60, 100, 60, 100, 40, 60, 100, 190]
      end
    end
  end
  
  def consignment_rows
    if @documents == "customers_pdf"
      arr = [["#{Consignment.human_attribute_name :customer_code}",
              "#{Consignment.human_attribute_name :customer_name}",
              "#{Consignment.human_attribute_name :product_code}",
              "#{Consignment.human_attribute_name :product_name}",
              "委託残",
              "#{User.human_attribute_name :name}",
              "#{Consignment.human_attribute_name :ship_date}",
              "#{Consignment.human_attribute_name :serial_number}",
              "#{Consignment.human_attribute_name :note}"
            ]]
            
      @customers_pdf.each do |customer_id_number, consignments|
        arr << [Customer.find(customer_id_number).code, Customer.find(customer_id_number).name, "", "", "", "", "", "", ""]
        consignments.each do |consignment|
        arr << ["",
                "",
                Product.find(consignment.product_id_number).code,
                Product.find(consignment.product_id_number).name,
                consignment.quantity - consignment.stocks.map { |s| s.return_quantity }.sum - consignment.stocks.map { |s| s.sales_quantity }.sum,
                User.find(consignment.user_id).name,
                consignment.ship_date.strftime("%Y年%m月%d日"),
                consignment.serial_number,
                consignment.note
              ]
        end
      end
    end
    # return arr
    
    if @documents == "products_pdf"
      arr = [["#{Consignment.human_attribute_name :product_code}",
              "#{Consignment.human_attribute_name :product_name}",
              "#{Consignment.human_attribute_name :customer_code}",
              "#{Consignment.human_attribute_name :customer_name}",
              "委託残",
              "#{User.human_attribute_name :name}",
              "#{Consignment.human_attribute_name :ship_date}",
              "#{Consignment.human_attribute_name :serial_number}",
              "#{Consignment.human_attribute_name :note}"
            ]]
      
      @products_pdf.each do |product_id_number, consignments|
        arr << [Product.find(product_id_number).code, Product.find(product_id_number).name, "", "", "", "", "", "", ""]
        consignments.each do |consignment|
        arr << ["",
                "",
                Customer.find(consignment.customer_id_number).code,
                Customer.find(consignment.customer_id_number).name,
                consignment.quantity - consignment.stocks.map { |s| s.return_quantity }.sum - consignment.stocks.map { |s| s.sales_quantity }.sum,
                User.find(consignment.user_id).name,
                consignment.ship_date.strftime("%Y年%m月%d日"),
                consignment.serial_number,
                consignment.note
              ]
        end
      end
    end
    # return arr
    
    if @documents == "users_pdf"
      arr = [["#{User.human_attribute_name :name}",
              "#{Consignment.human_attribute_name :product_code}",
              "#{Consignment.human_attribute_name :product_name}",
              "#{Consignment.human_attribute_name :customer_code}",
              "#{Consignment.human_attribute_name :customer_name}",
              "委託残",
              "#{Consignment.human_attribute_name :ship_date}",
              "#{Consignment.human_attribute_name :serial_number}",
              "#{Consignment.human_attribute_name :note}"
            ]]
      
      @users_pdf.each do |user_id, consignments|
        arr << [User.find(user_id).name, "", "", "", "", "", "", "", ""]
        consignments.each do |consignment|
        arr << ["",
                Product.find(consignment.product_id_number).code,
                Product.find(consignment.product_id_number).name,
                Customer.find(consignment.customer_id_number).code,
                Customer.find(consignment.customer_id_number).name,
                consignment.quantity - consignment.stocks.map { |s| s.return_quantity }.sum - consignment.stocks.map { |s| s.sales_quantity }.sum,
                consignment.ship_date.strftime("%Y年%m月%d日"),
                consignment.serial_number,
                consignment.note
              ]
        end
      end
    end
    return arr
  end
end