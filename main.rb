# -*- coding: utf-8 -*-

require 'optparse'
require_relative 'chasers/base'
require_relative 'chasers/active'
require_relative 'chasers/silent'
require_relative 'connection'
require_relative 'utils'

def start(host='127.0.0.1', port=40000, username='hoge')
  # クライアントを開始する関数
  c = Connection.new(host, port)
  ch = ActiveCHaser.new(c, username)
  ch.start
end

def main
  args = {}
  OptionParser.new do |parser|
    parser.on('-p', '--port port', Integer) { |v| args[:port] = v }
    parser.on('--host hostname', String) { |v| args[:host] = v }
    parser.on('-u', '--username', String) { |v| args[:username] = v }
    parser.parse!
  end
  p args
  start(args[:host], args[:port], args[:username])
end

if __FILE__ == $0
  main
end
