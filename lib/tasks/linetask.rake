namespace :line_push do 
  desc "linebot実行"
  task line_push_memo: :environment do
    #ログ
    # logger = Logger.new 'log/linetask.log'

    #ここから処理
    def text
      date = Date.today
      post_num = Post.find(1)
      
      case date.strftime('%-d')
        when post_num.month_day.to_s
          if post_num.month_check == true
            post_num.month_notice + year_text
          else
            year_text
          end
        else
          # "1日1回動作テスト\n#{DateTime.now.strftime('%Y/%m/%d %H時%M分')}#{User.find(1).name}#{date.strftime('%d')}"
          year_text
      end
    end

    def year_text
      post_num = Post.find(1)
      if post_num.year_check == true
        date = Date.today
        month = date.strftime('%-m')
        day = date.strftime('%-d')
        
        if month == post_num.year_month.to_s && day == post_num.year_day.to_s
          "#{post_num.year_notice}"
        else
          ""
        end
      else
        ""
      end
    end
    
    message = {
      type: 'text',
      text: text
    }
    
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
    # response = client.push_message(ENV["LINE_CHANNEL_USER_ID"], message)
    response = client.broadcast(message)
    p response
    
    p "OK" #デバッグ
  end
  
  task line_push_reminder: :environment do
    
    def reminder_text
      post_num = Post.find(1)
      if post_num.reminder_check == true
        reminder = post_num.reminder_month
        reminder_text = post_num.reminder_notice
        elapse = Consignment.where("ship_date < ? ", Time.current - reminder.to_i.month).where(done: false)
        if elapse.count > 0
          "#{reminder}ヶ月以上経過している委託が#{elapse.count}件あります。確認してください。\n" + reminder_text
        else
          ""
        end
      end
    end
    
    message = {
      type: 'text',
      text: reminder_text
    }
    
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
    
    response = client.broadcast(message)
    p response
    
    p "OK"  #デバッグ
  end
  
  # テスト送信様
  task test_push: :environment do
    message = {
      type: 'text',
      text: "テスト送信"
    }
    
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
    
    response = client.broadcast(message)
    p response
    
    p "OK"  #デバッグ
  end
end