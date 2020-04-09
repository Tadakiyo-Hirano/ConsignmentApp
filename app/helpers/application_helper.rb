module ApplicationHelper
  
  # ブラウザタブタイトル表示
  def full_title(page_name = "")
    base_title = "委託商品管理"
    if page_name.empty?
      base_title
    else
      page_name + " | " + base_title
    end
  end
end
