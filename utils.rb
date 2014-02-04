# -*- coding: utf-8 -*-

def strarr_to_intarr(val)
  # 文字列をintのリストにする
  result = Array.new
  val.each_char { |c|
    result.push(c.to_i)
  }
  #return val.map{ |s| s.to_i }
  return result
end
