# -*- encoding: utf-8 -*-

require './message.rb'

class Event
  
  #リプライの種類を定義
  @@last = 0
  @@list = [
            "Adlib",
            "Version",
            "Omikuji"
          ]
  
  #めっさげ定義を呼んどく
  @@message = Message::new()
  
  def reply?(str)
    
    if /@tsksee/ =~ str then
      return true
    end
    
    return false
    
  end
  
  #リプライであればその種類を返す，定義の条件を定義
  def kind?(str)
    
    @@last = 0

    #バージョン
    if /(バージョン|ばーじょん|version)/ =~ str then
      @@last = 1
    end
    
    #おみくじ
    if /(お|オ|ｵ|O|o|Ｏ|ｏ)(み|ミ|ﾐ|[MmＭｍ][IiIi])(く|ク|ｸ|[KkＫｋ][UuＵｕ])(じ|ジ|ｼﾞ|[JjＪｊZzＺｚ][IiIi])/ =~ str then
      @@last = 2
    end
    
    puts "LAST:" + @@list[@@last]
    
    return @@last
    
  end
  
  #ただ単に前回処理したリプライの種類を返すヤツ
  def last
    return @@list[@@last]
  end
  
  #ふぁぼっていいか確認するワケね
  def favorite?(str)
    
    if /tsksee|つくしー/ =~ str and /@tsksee/ !~ str then
      return true
    end
    
    return false
  end
  
  
  
  #とりあえず全部ここで必要なチェック済ませるってワケ
  def run(str, screen_name, id)
    
    puts "==[Checker]========================================"
    
    #リプライ送ってもいいか確認して結果を出力
    puts "Reply? : " + reply?(str).to_s
    
    #リプライの処理に入る
    if reply?(str) == true then
      
      #リプライの種類を照らし合わせる
      puts "Reply kind : " + kind?(str).to_s + "(" + last.to_s + ")"
      
      #リプライの文章を取ってくるんやね
      replytext = @@message.replygen(kind?(str).to_i)
      puts replytext
      
      #リプライの送信
      unless replytext == "" then
        Twitter.update "@#{screen_name} #{replytext}", {"in_reply_to_status_id"=>id}
      end
      
    end
    
    #ふぁぼの確認
    puts "Favorite? : " + favorite?(str).to_s
    
    #ふぁぼの処理に入る
    if favorite?(str) == true then
      
      #ここでふぁぼるワケ
      Twitter.favorite(id)
      
    end
    
    puts "==================================================="
    
  end
  
end