require_relative 'const'

# 履歴は多すぎても多分意味ないので
MAX_HISTORY_COUNT = 5

class MapCell
  # マップの1セルの情報
  # いつ更新されたかと更新履歴を持つ
  attr_reader :celltype, :turn
  def initialize(celltype, turn)
    @celltype = celltype
    @turn = turn
    @history = Array.new
  end

  def is_floor
    return @celltype == TYPE_FLOOR
  end

  def is_enemy
    return @celltype == TYPE_ENEMY
  end
  
  def is_block
    return @celltype == TYPE_BLOCK
  end

  def is_item
    return @celltype == TYPE_ITEM
  end

  def update(celltype, turn)
    @history.push([@celltype, @turn])
    # 最大数を超えないように切り詰め
    @history = @history[(@history.size-MAX_HISTORY_COUNT).negative_to_zero..@history.size-1]
    @celltype = celltype
    @turn = turn
  end
end

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

  def get_x_list
    # マッピング済みのX座標のリストを返す
    return @data.keys.map{ |position| position[0] }.sort
  end

  def get_y_list
    # マッピング済みのY座標のリストを返す
    return @data.keys.map{ |position| position[1] }.sort
  end

  def get_left
    # 一番左のX座標
    return self.get_x_list.min
  end

  def get_right
    # 一番右のX座標
    return self.get_x_list.max
  end

  def get_up
    # 一番上のY座標
    return self.get_y_list.max
  end

  def get_down
    # 一番下のY座標
    return self.get_y_list.min
  end
  
  def get_width
    # マップの幅
    @width = self.get_right - self.get_left + 1
    return self.get_right - self.get_left + 1
  end
  
  def get_height
    # マップの高さ
    @height = self.get_up - self.get_down + 1
    return self.get_up - self.get_down + 1
  end

  def get_cell(position, gt_turn=nil)
    # 指定位置の情報を取得
    # gt_turnを指定すると指定ターン以前の場合はnilを返す
    cell = @data[position]
    if gt_turn and cell and cell.turn < gt_runt
      return nil
    end
    return cell
  end

  def update_cell(position, celltype, turn)
    # 指定位置の情報を更新
    cell = get_cell(position)
    if !cell
      @data[position] = MapCell.new(celltype, turn)
    else
      cell.update(celltype, turn)
    end
  end

  def display_text(gt_turn=nil, position_self=nil)
    # 文字表現でマップを返す
    # X: 壁
    # E: 的
    # *: アイテム
    # _: 床
    # 空白: 情報なし

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

