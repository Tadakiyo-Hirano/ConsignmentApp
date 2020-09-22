namespace :line_push do 
  desc "linebot実行"
  task line_push_memo: :environment do
    #ログ
    # logger = Logger.new 'log/linetask.log'

    #ここから処理を書いていく
    def text
      date = Date.today

      case date.strftime('%d')
        when "20"
          "明日は締日です。委託品の売上、回収処理確認をお願いします。" + metal_text
        else
          "1日1回動作テスト\n#{DateTime.now.strftime('%Y/%m/%d %H時%M分')}#{User.find(1).name}#{date.strftime('%d')}"
      end
    end

    def metal_text
      date = Date.today
      day = date.strftime('%m%d')
      if day == "0420"
        "\n棚卸しもありますので、委託品の最終チェックも提出お願いします。"
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

    #デバッグのため
    p "ここまでOK"
  end
end