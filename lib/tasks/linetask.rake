namespace :line_push do 
  desc "linebot実行"
  task line_push_memo: :environment do
    #ログ
    # logger = Logger.new 'log/linetask.log'

    #ここから処理
    def text
      date = Date.today

      case date.strftime('%-d')
        when Post.find(1).month_day.to_s
          Post.find(1).month_notice + year_text
        else
          # "1日1回動作テスト\n#{DateTime.now.strftime('%Y/%m/%d %H時%M分')}#{User.find(1).name}#{date.strftime('%d')}"
          year_text
      end
    end

    def year_text
      date = Date.today
      month = date.strftime('%-m')
      day = date.strftime('%-d')
      if month == Post.find(1).year_month.to_s && day == Post.find(1).year_day.to_s
        "#{Post.find(1).year_notice}"
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
      elapse = Consignment.where("ship_date < ? ", Time.current - 1.month).where(done: false)
      if elapse.count > 0
        "3ヶ月以上経過している委託が#{elapse.count}件あります。確認してください。\nhttps://www.google.com/"
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
end