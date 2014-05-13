# -*- coding: utf-8 -*-

require 'logger'
require_relative '../const'
require_relative '../connection'
require_relative '../utils'
require_relative '../maps'

LOGGER = Logger.new(STDOUT)

class ConnectionCloseSignal < Exception
end

FLAG_CONNECTION_CLOSE = 0

class CHaser
  attr_reader :x, :y
  def initialize(connection, username)
    @connection = connection
    @username = username
    @x = 0
    @y = 0
    @turn = 0
    @map = CHaserMap.new
    self.setUp
  end

  def command(cmd)
    LOGGER.info('send command [%s]' % cmd)
    return @connection.send("%s\n" % cmd)
  end

  def receive
    result = @connection.recv.strip
    LOGGER.info('data received [%s]' % result)
    return result
  end

  def receive_info
    result = self.receive
    info = result.to_intarr
    raise ConnectionCloseSignal if info[0] == FLAG_CONNECTION_CLOSE
    return info[1..info.size-1]
  end

  def update_map_normal(info)
    # 通常の周囲8マスの情報でマップを更新
    def update(cell_y, line_info)
      line_info.each_with_index do |celltype, idx|
        cell_x = @x - 1 + idx
        @map.update_cell([cell_x, cell_y], celltype, @turn)
      end
    end
    # 1列目
    update(@y + 1, info[0..2])
    # 2列目
    update(@y, info[3..5])
    # 3列目
    update(@y - 1, info[6..8])
  end

  def update_map_look(info, direction)
    # lookコマンドの情報でマップを更新
    def update(func_cell_x, func_cell_y, line_info)
      line_info.each_with_index do |celltype, idx|
        cell_x = func_cell_x.call(idx)
        cell_y = func_cell_y.call(idx)
        @map.update_cell([cell_x, cell_y], celltype, @turn)
      end
    end
    
    case direction
    when LEFT
      # 1列目
      update(lambda {|idx| @x - 3 + idx }, lambda {|idx| @y + 1}, info[0..2])
      # 2列目
      update(lambda {|idx| @x - 3 + idx }, lambda {|idx| @y}, info[3..5])
      # 3列目
      update(lambda {|idx| @x - 3 + idx }, lambda {|idx| @y - 1}, info[6..8])
    when RIGHT
      # 1列目
      update(lambda {|idx| @x + 1 + idx }, lambda {|idx| @y + 1}, info[0..2])
      # 2列目
      update(lambda {|idx| @x + 1 + idx }, lambda {|idx| @y}, info[3..5])
      # 3列目
      update(lambda {|idx| @x + 1 + idx }, lambda {|idx| @y - 1}, info[6..8])
    when UP
      # 1列目
      update(lambda {|idx| @x - 1 + idx }, lambda {|idx| @y + 3}, info[0..2])
      # 2列目
      update(lambda {|idx| @x - 1 + idx }, lambda {|idx| @y + 2}, info[3..5])
      # 3列目
      update(lambda {|idx| @x - 1 + idx }, lambda {|idx| @y + 1}, info[6..8])
    when DOWN 
      # 1列目
      update(lambda {|idx| @x - 1 + idx }, lambda {|idx| @y - 3}, info[0..2])
      # 2列目
      update(lambda {|idx| @x - 1 + idx }, lambda {|idx| @y - 2}, info[3..5])
      # 3列目
      update(lambda {|idx| @x - 1 + idx }, lambda {|idx| @y - 1}, info[6..8])
    end
  end

  def update_map_search(info, direction)
    # searchコマンドの情報でマップを更新
    # direction: 方向
    def update(func_cell_x, func_cell_y, info)
      info.each_with_index do |celltype, idx|
        cell_x = func_cell_x.call(idx)
        cell_y = func_cell_y.call(idx)
        @map.update_cell([cell_x, cell_y], celltype, @turn)
      end
    end

    case direction
    when LEFT
      update(lambda {|idx| @x - 1 - idx}, lambda {|idx| @y}, info)
    when RIGHT
      update(lambda {|idx| @x + 1 + idx}, lambda {|idx| @y}, info)
    when UP
      update(lambda {|idx| @x}, lambda {|idx| @y + 1 + idx}, info)
    when DOWN
      update(lambda {|idx| @x}, lambda {|idx| @y - 1 - idx}, info)
    end
  end

  ################
  # 補助コマンド
  ################
  def username
    return self.command(@username)
  end

  def getReady
    self.command('gr')
    info = self.receive_info
    self.update_map_normal(info)
    return info
  end

  def turnEnd
    self.command('#')
  end

  ###############
  # 移動系
  ###############
  def walkRight
    self.command('wr')
    @x += 1
    info = self.receive_info
    self.update_map_normal(info)
    return info
  end

  def walkLeft
    self.command('wl')
    @x -= 1
    info = self.receive_info
    self.update_map_normal(info)
    return info
  end

  def walkUp
    self.command('wu')
    @y += 1
    info = self.receive_info
    self.update_map_normal(info)
    return info
  end

  def walkDown
    self.command('wd')
    @y -= 1
    info = self.receive_info
    self.update_map_normal(info)
    return info
  end

  ##############
  # 広範囲探索
  #############
  def lookRight
    self.command('lr')
    info = self.receive_info
    self.update_map_look(info, RIGHT)
    return info
  end

  def lookLeft
    self.command('ll')
    info = self.receive_info
    self.update_map_look(info, LEFT)
    return info
  end

  def lookUp
    self.command('lu')
    info = self.receive_info
    self.update_map_look(info, UP)
    return info
  end

  def lookDown
    self.command('ld')
    info = self.receive_info
    self.update_map_look(info, DOWN)
    return info
  end

  ##############
  # 前方探索
  ##############
  def searchRight
    self.command('sr')
    info = self.receive_info
    self.update_map_search(info, RIGHT)
    return info
  end

  def searchLeft
    self.command('sl')
    info = self.receive_info
    self.update_map_search(info, LEFT)
    return info
  end

  def searchUp
    self.command('su')
    info = self.receive_info
    self.update_map_search(info, UP)
    return info
  end

  def searchDown
    self.command('sd')
    info = self.receive_info
    self.update_map_search(info, DOWN)
    return info
  end

  ################
  # ブロック設置
  ################
  def putRight
    self.command('pr')
    info = self.receive_info
    self.update_map_normal(info)
    return info
  end

  def putLeft
    self.command('pl')
    info = self.receive_info
    self.update_map_normal(info)
    return info
  end

  def putUp
    self.command('pu')
    info = self.receive_info
    self.update_map_normal(info)
    return info
  end

  def putDown
    self.command('pd')
    info = self.receive_info
    self.update_map_normal(info)
    return info
  end

  def start
    # 実行ループ
    self.username

    begin
      loop do
        begin
          buf = self.receive
          next if !buf.start_with?('@')
          # getReadyして周囲の情報を取得
          info = self.getReady
          # ターン情報更新
          @turn += 1
          # ユーザ定義の記述ポイントへ
          # マップ情報のみ渡す
          self.run(info)
          self.turnEnd
        rescue Interrupt
          break
        rescue ConnectionCloseSignal
          break
        end
      end
    ensure
      self.tearDown
    end
  end

  def run(info)
    raise NotImplementedError
  end

  def setUp
  end

  def tearDown
  end
end
