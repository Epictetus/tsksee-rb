# -*- encoding: utf-8 -*-

require 'twitter'
require 'tweetstream'
require "cgi"
require 'pp'
require './event.rb'
require './setting.rb'

$VERSION = "0.0.0.3Rb"

event = Event.new()

#避けては通れない
$Usual = Twitter::Client.new(
  :consumer_key       => CONSUMER_KEY,
  :consumer_secret    => CONSUMER_SECRET,
  :oauth_token        => OAUTH_TOKEN,
  :oauth_token_secret => OAUTH_TOKEN_SECRET
)
$Admin = Twitter::Client.new(
  :consumer_key       => CONSUMER_KEY_ADMIN,
  :consumer_secret    => CONSUMER_SECRET_ADMIN,
  :oauth_token        => OAUTH_TOKEN_ADMIN,
  :oauth_token_secret => OAUTH_TOKEN_SECRET_ADMIN
)

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

end.on_direct_message do |direct_message|
  
  #代入=======================================================
    id = direct_message.sender.id
    text = CGI.unescapeHTML(direct_message.text)
    screen_name = direct_message.sender.screen_name
  #==========================================================
  puts "==================================================="
  puts "@#{screen_name} (#{id})"
  puts text
  
  event.run_dm(text, screen_name, id)
  
end.userstream do |status|
  
  #代入 =====================================================
    id = status.id
    text = CGI.unescapeHTML(status.text)
    screen_name = status.user.screen_name
  #========================================================
  
  puts "==================================================="
  
  puts "@#{screen_name}"
  puts text
  
  #公式RT除いてテキストを処理するワケ(リプライとかふぁぼとか)
  unless status.retweeted_status.respond_to?("retweeted") == true then
    
    event.run(text, screen_name, id)
    
  end
  
end