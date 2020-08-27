class LinebotController < ApplicationController
  require 'line/bot'
  protect_from_forgery except: :callback
  
  def callback
    client = Line::Bot::Client.new { |config|
    config.channel_secret = ""
    config.channel_token = ""
    } 
    
    message = {
    type: 'text',
    text: '(送信したいメッセージ)'
    }
    user_id = ""
    response = client.push_message(user_id, message)

    head :ok
  end
end
