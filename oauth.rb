require 'rubygems' 
require 'Twitter' 
consumer_token = 'XHC32mRQQg4d2A3Gb2xSFA' 
consumer_secret = 'HPsMqbPU0yWWxh5vBXqKP17qowgKoeecTtXsrXvc' 
oauth = Twitter::OAuth.new(consumer_token, consumer_secret) 
request = oauth.consumer.get_request_token 
puts request.authrize_url #<- ここで認証URLを表示させる 
