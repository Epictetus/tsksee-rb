# -*- encoding: utf-8 -*-
class Reply
  
  @@last = 0
  @@list = [
            "Adlib",
            "Version",
            "Omikuji"
          ]
  
  def reply?(str)
    
    if /@tsksee/ =~ str then
      return true
    end
    
    return false
    
  end
  
  def kind?(str)
    
    @@last = 0

    #バージョン
    if /(バージョン|ばーじょん|version)/ =~ str then
      @@last = 1
    end
    
    #おみくじ
    if /(お|ｵ|O|o|Ｏ|ｏ)(み|ﾐ|[MmＭｍ][IiIi])(く|ｸ|[KkＫｋ][UuＵｕ])(じ|ｼﾞ|[JjＪｊ][IiIi])/ =~ str then
      @@last = 2
    end
    
    puts "LAST:" + @@list[@@last]
    
    return @@last
    
  end
  
  def last
    return @@list[@@last]
  end
  
end