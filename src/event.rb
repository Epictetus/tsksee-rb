# -*- encoding: utf-8 -*-

require './message.rb'

class Event
  
  #リプライの種類を定義
  @@last     = 0
  @@list     = [
                 "Adlib",
                 "Version",
                 "Omikuji"
               ]
  @@cmd      = [
                "Noaction",
                "Version"
               ]
  @@cmd[100] = "Say[Admin]"
  
  #めっさげ定義を呼んどく
  @@message = Message::new()
  
  def reply?(str, screen_name)
    
    if /@tsksee/ =~ str and /^tsksee+$/ !~ screen_name then
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
  
  def dm_kind?(str, screen_name, id)
    
    if /^tsksee+$/ =~ screen_name then
      return 0
    end
    
    #バージョン情報を返す
    if /^\/[Vv][Ee][Rr][Ss][Ii][Oo][Nn]/ =~ str then
      return 1
    end
    
    #管理権限があるかどうか調べる，無ければ無視
    unless /111241653/ =~ id.to_s then
      return 0
    end
    
    #botに直接発言させる
    if /^\/[Ss][Aa][Yy]/ =~ str then
      return 100
    end
    
    return 0
  end
  
  
  
  #とりあえず全部ここでリプライに必要なチェック済ませるってワケ
  def run(str, screen_name, id)
    
    puts "==[Checker]========================================"
    
    #リプライ送ってもいいか確認して結果を出力
    puts "Reply? : " + reply?(str, screen_name).to_s
    
    #リプライの処理に入る
    if reply?(str, screen_name) == true then
      
      #リプライの種類を照らし合わせる
      puts "Reply kind : " + kind?(str).to_s + "(" + last.to_s + ")"
      
      #リプライの文章を取ってくるんやね
      replytext = @@message.replygen(kind?(str).to_i)
      puts replytext
      
      #リプライの送信
      unless replytext == "" then
        $Usual.update("@#{screen_name} #{replytext}", {"in_reply_to_status_id"=>id})
      end
      
    end
    
    #ふぁぼの確認
    puts "Favorite? : " + favorite?(str).to_s
    
    #ふぁぼの処理に入る
    if favorite?(str) == true then
      
      #ここでふぁぼるワケ
      $Usual.favorite(id)
      
    end
    
    puts "==================================================="
    
  end
  
  #ここでDMコマンド処理
  def run_dm(str, screen_name, id)
    
    
    puts "==[DM-Checker]====================================="
    
    dm_kind = dm_kind?(str, screen_name, id).to_i
    
    #DMをパーサにかける
    puts "Kind : #{@@cmd[dm_kind]}"
    
    case dm_kind
    when 0
    when 1
      $Usual.direct_message_create(screen_name, $VERSION)
    when 100
      $Admin.update("[中の人より] #{str.split(" ", 2)[1]}")
    end
    
    puts "==================================================="
    
  end
  
end