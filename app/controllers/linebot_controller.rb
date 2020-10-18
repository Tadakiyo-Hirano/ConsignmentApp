class LinebotController < ApplicationController
  require 'line/bot'
  require "json"
  
  protect_from_forgery except: :callback
  
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end
  
  def callback
    body = request.body.read
 
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end
    return 'ok'
  end
end
