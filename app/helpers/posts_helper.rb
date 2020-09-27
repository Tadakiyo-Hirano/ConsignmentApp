module PostsHelper
  TRUE_MSG = "通知設定はONの状態です。"
  FALSE_MSG = "通知設定はOFFの状態です。"
  
  def month_notification
    case @post.month_check
    when true
      TRUE_MSG
    when false
      FALSE_MSG
    end
  end
  
  def year_notification
    case @post.year_check
    when true
      TRUE_MSG
    when false
      FALSE_MSG
    end
  end
  
  def reminder_notification
    case @post.reminder_check
    when true
      TRUE_MSG
    when false
      FALSE_MSG
    end
  end
end
