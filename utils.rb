# -*- coding: utf-8 -*-

class Numeric
  # 負の数の場合0を返す
  # 正の数の場合はそのまま
  # === Return
  # 0か正の数
  def negative_to_zero
    return 0 if self < 0
    return self
  end
end

def chasers_require
  Dir.glob("./chasers/*.rb").each do |ch|
    require ch
  end
end

def load_class(str)
  return Object.const_get(str)
end

def strarr_to_intarr(val)
  # 文字列をintのリストにする
  result = Array.new
  val.each_char { |c|
    result.push(c.to_i)
  }
  #return val.map{ |s| s.to_i } # 文字列にmap使えなかった
  return result
end
