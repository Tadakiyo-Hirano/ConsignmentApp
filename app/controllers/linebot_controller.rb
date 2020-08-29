class LinebotController < ApplicationController
  require 'line/bot'
  protect_from_forgery except: :callback
  
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ""
      config.channel_token = ""
    }
  end
  
  def callback
    @user_num = Consignment.find(1).user_id
    # user_id = ""
    body = request.body.read
 
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end
 
    events = client.parse_events_from(body)
 
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          if event.message['text'] == "商品"
            message = {
              type: 'text',
              # text: event.message['text']
              text: "#{Time.now} #{event.message['text']}"
              # text: "#{User.find(@user_num).name} #{Date.current}"
            }
            # client.push_message(user.uid, message)  
            client.push_message(event['source']['userId'], message)
          elsif event.message['text'] == "得意先"
            message = {
              type: 'text',
              # text: event.message['text']
              text: "#{Time.now} #{event.message['text']}"
            }
            client.push_message(event['source']['userId'], message)
          else
            message = {
              type: 'text',
              text: "商品別在庫の確認は「商品」、\n得意先別在庫の確認は「得意先」と入力してください。"
            }
            client.push_message(event['source']['userId'], message)
          end
        end      
      end
      head :ok
    end
  end
end
