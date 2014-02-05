# -*- coding: utf-8 -*-

require 'optparse'
# require_relative 'chasers/base'
# require_relative 'chasers/active'
# require_relative 'chasers/silent'
require_relative 'connection'
require_relative 'utils'

chasers_require

def start(host='127.0.0.1', port=40000, username='hoge', klass='SilentCHaser')
  # クライアントを開始する関数
  chaser_class = load_class(klass)
  c = Connection.new(host, port)
  ch = chaser_class.new(c, username)
  ch.start
end

def main
  args = {}
  OptionParser.new do |parser|
    parser.on('-p', '--port=PORT', /[0-9]+/, Integer, 'ポート番号') { |v| args[:port] = v }
    parser.on('--host=HOSTNAME', String, 'ホスト名, IPアドレス') { |v| args[:host] = v }
    parser.on('-u', '--username[=USERNAME]', String, 'ユーザ名') { |v| args[:username] = v }
    parser.on('--chaser[=CLASS]', String, '実際に動かすクライアントをクラス名で指定') { |v| args[:chaser] = v }
    parser.on
    parser.parse!
  end
  if !args[:host]
    args[:host] = '127.0.0.1'
  end
  if !args[:port]
    args[:port] = 40000
  end
  if !args[:username]
    args[:username] = 'hoge'
  end
  if !args[:chaser]
    args[:chaser] = 'SilentCHaser'
  end
  start(args[:host], args[:port], args[:username], args[:chaser])
end

if __FILE__ == $0
  main
end
