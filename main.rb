# -*- encoding: utf-8 -*-

require 'twitter'
require 'tweetstream'
require 'pp'
require './event.rb'
require './setting.rb'

$VERSION = "0.0.0.2Rb"

event = Event.new()

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
  puts text
  
  #公式RT除いてテキストを処理するワケ(リプライとかふぁぼとか)
  unless status.retweeted_status.respond_to?("retweeted") == true then
    
    event.run(text, screen_name, id)
    
  end
  
end