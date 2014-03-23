require_relative 'const'
#
#= マップ作成，保存するクラスライブラリ
#
#Author:: Nobuyuki SAKAI
#Date:: 2014/03/19

# 履歴は多すぎても多分意味ないので
MAX_HISTORY_COUNT = 5

# マップの1セルの情報
# いつ更新されたかと更新履歴を持つ
class MapCell
  attr_reader :celltype, :turn
  def initialize(celltype, turn)
    @celltype = celltype
    @turn = turn
    @history = Array.new
  end

  # _celltype_が床かどうか判定
  # Return:: true or false
  def is_floor
    return @celltype == TYPE_FLOOR
  end

  # _celltype_が敵かどうか判定
  # Return:: true or false
  def is_enemy
    return @celltype == TYPE_ENEMY
  end
  
  # _celltype_がブロックかどうか判定
  # Return:: true or false
  def is_block
    return @celltype == TYPE_BLOCK
  end

  # _celltype_がアイテムかどうか判定
  # Return:: true or false
  def is_item
    return @celltype == TYPE_ITEM
  end

  # === セルの履歴を更新するメソッド
  # Param:: _celltype_, _turn_
  def update(celltype, turn)
    @history.push([@celltype, @turn])
    # 最大数を超えないように切り詰め
    @history = @history[(@history.size-MAX_HISTORY_COUNT).negative_to_zero..@history.size-1]
    @celltype = celltype
    @turn = turn
  end
end

# == マップを作成するクラス
class CHaserMap
  attr_reader :width, :height

  def initialize
    @data = { 
      [0, 0] => TYPE_FLOOR,
    }
    @data[[0, 0]] = MapCell.new(TYPE_FLOOR, 0)
    @width = self.get_width
    @height = self.get_height
  end

  # マッピング済みのX座標のリストを返す
  # Return:: マッピング済みのX座標のリスト
  def get_x_list
    return @data.keys.map{ |position| position[0] }.sort
  end

  # マッピング済みのY座標のリストを返す
  # Return:: マッピング済みのY座標のリスト
  def get_y_list
    return @data.keys.map{ |position| position[1] }.sort
  end

  # 一番左のX座標を取得するメソッド
  # Return:: X座標の最小値
  def get_left
    return self.get_x_list.min
  end

  # 一番右のX座標を取得するメソッド
  # Return:: X座標の最大値
  def get_right
    return self.get_x_list.max
  end

  # 一番上のY座標を取得するメソッド
  # Return:: Y座標の最大値
  def get_up
    return self.get_y_list.max
  end

  # 一番下のY座標を取得するメソッド
  # Return:: Y座標の最小値
  def get_down
    return self.get_y_list.min
  end
  
  # マップの幅を取得するメソッド
  # Return:: マップの幅
  def get_width
    @width = self.get_right - self.get_left + 1
    return self.get_right - self.get_left + 1
  end
  
  # マップの高さを取得するメソッド
  # Return:: マップの高さ
  def get_height
    @height = self.get_up - self.get_down + 1
    return self.get_up - self.get_down + 1
  end
  
  # 指定位置の情報を取得するメソッド
  # Param:: _position_, gt_turn
  # _position_:: 指定位置
  # _gt_turn_:: gt_turnを指定すると指定ターン以前の場合はnilを返す
  # Return:: セル情報
  def get_cell(position, gt_turn=nil)
    cell = @data[position]
    if gt_turn and cell and cell.turn < gt_turn
      return nil
    end
    return cell
  end

  # 指定位置の情報を更新するメソッド
  # Param:: _position_, _celltype_, _turn_
  # _position_:: 指定位置
  # _celltype_:: セルのタイプ
  # _turn_:: ターン
  def update_cell(position, celltype, turn)
    cell = get_cell(position)
    if !cell
      @data[position] = MapCell.new(celltype, turn)
    else
      cell.update(celltype, turn)
    end
  end

  # 文字表現でマップを返す
  # Param:: _gt_turn_, _position_self_
  # X: 壁
  # E: 的
  # *: アイテム
  # _: 床
  # 空白: 情報なし
  def display_text(gt_turn=nil, position_self=nil)
    # マップの上下左右を取得
    l, r, u, d = self.get_left, self.get_right, self.get_up, self.get_down
    text = ""
    # 左上から生成
    (d..(u + 1)).reverse_each do |y|
      (l..(r + 1)).each do |x|
        if [x, y] == position_self
          text += '@'
          next
        end
        if [x, y] == [0, 0]
          text += 'S'
          next
        end
        cell = self.get_cell([x, y], gt_turn=gt_turn)
        if !cell
          text += ' '
        elsif cell.is_floor
          text += '_'
        elsif cell.is_enemy
          text += 'E'
        elsif cell.is_block
          text += 'X'
        elsif cell.is_item
          text += '*'
        end
      end
      text += "\n"
    end
    return text
  end
end

