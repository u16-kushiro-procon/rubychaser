# -*- coding: utf-8 -*-

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
  #return val.map{ |s| s.to_i }
  return result
end
