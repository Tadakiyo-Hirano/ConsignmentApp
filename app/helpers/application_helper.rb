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
  
  # 得意先コード表示
  def code(object)
    format('%03d', object.code)
  end
  
  # 新規登録、編集直後に丸印のバッジを表示する
  def stamp(created_at, updated_at)
    if (created_at + 3.minutes) > DateTime.current && created_at == updated_at
      "new_stamp"
    elsif (updated_at + 3.minutes) > DateTime.current
      "update_stamp"
    end
  end
  
  # 検索フォームが未入力の時
  def search_none
    @search_params.blank? || @search_params[:code] == "" && @search_params[:name] == ""
  end
  
  # 検索結果の表示
  def search_results_text(search_hash)
    if @search_params[:code] == "" && @search_params[:name] == ""
      "検索ワードを入力してください。"
    elsif params[:search].present?
      "検索結果 #{search_hash.count}件"
    end
  end
  
  def search_results_link(path)
    if @search_params[:code] == "" && @search_params[:name] == ""
      return
    elsif params[:search].present?
      link_to "戻る", path
    end
  end
end
