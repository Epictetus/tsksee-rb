# -*- encoding: utf-8 -*-

require 'twitter'
require 'tweetstream'
require 'pp'
require './reply.rb'
require './message.rb'
require './setting.rb'


reply = Reply.new()
message = Message.new()

#避けては通れない
Twitter.configure do |config|
  config.consumer_key = CONSUMER_KEY
  config.consumer_secret = CONSUMER_SECRET
  config.oauth_token = OAUTH_TOKEN
  config.oauth_token_secret = OAUTH_TOKEN_SECRET
end

TweetStream.configure do |config|
  config.consumer_key       = CONSUMER_KEY
  config.consumer_secret    = CONSUMER_SECRET
  config.oauth_token        = OAUTH_TOKEN
  config.oauth_token_secret = OAUTH_TOKEN_SECRET
  config.auth_method        = :oauth
end

puts "Connecting to Twitter..."

TweetStream::Client.new.on_error do |message|
  puts "Error"
  pp message
end.userstream do |status|
  pp status
  
  #代入 =====================================================
    id = status.id
    text = status.text
    screen_name = status.user.screen_name
  #========================================================
  
  puts "==================================================="
  
  puts "@" + screen_name
  puts status.text
  
  #公式RT除いてリプライの有無とか確認するワケ
  unless status.retweeted_status.respond_to?("retweeted") == true then
    
    puts "==[Reply Checker]=================================="
    
    kind = reply.kind?(text)
    
    puts "Reply? : " + reply.reply?(text).to_s
    
    if reply.reply?(text) == true then
      
      #リプライの種類を照らし合わせる
      puts "Reply kind : " + kind.to_s + "(" + reply.last.to_s + ")"
      
      #リプライの文章を取ってくるんやね
      replytext = message.replygen(kind.to_i)
      puts replytext
      
      #リプライの送信
      unless replytext == "" then
        Twitter.update "@#{screen_name} #{replytext}", {"in_reply_to_status_id"=>id}
      end
      
    end
    
    puts "==================================================="
    
  end
end