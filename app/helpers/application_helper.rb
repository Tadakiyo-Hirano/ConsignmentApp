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
  
  # 管理者とヘッダータイトル表示
  def header_title
    if current_admin
      content_tag(:li, class: "fas fa-user-cog") do
        "&nbsp;管理者権限".html_safe
      end
    else
      content_tag(:li, class: "fas fa-cubes") do
        "&nbsp;委託商品管理".html_safe
      end
    end
  end
end
