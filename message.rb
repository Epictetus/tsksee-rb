# -*- encoding: utf-8 -*-

class Message
  
  def replygen(mode)
    
    if mode == 1 then
      return "0.0.0.1Rb"
    end
    
    if mode == 2 then
      @buf_head = [
        "君の運勢は...",
        "テキトーだけどね,",
        "キサマの運勢は...",
        "おみゃーの運勢は...",
        "お主の運勢は",
        "気まぐれだけどね、たぶん",
        "気分だけどね君は",
        "",
        ""
        ]
      @buf_foot = [
        "じゃボケ",
        "でござる",
        "なんじゃ",
        "ｗｗｗｗｗｗｗｗｗｗｗ",
        "だよっ",
        "だよ",
        "なんじゃ"
        ]
      @body = [
        "大吉",
        "中吉",
        "小吉",
        "吉",
        "凶",
        "大凶"
        ]
      return "#{@buf_head[rand(@buf_head.size)]} #{@body[rand(@body.size)] + @buf_foot[rand(@buf_foot.size)]}"
    end
    
    return ""
  end
  
end