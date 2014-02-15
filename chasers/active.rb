# coding: utf-8

require_relative 'base'
require_relative '../const'

WALK_UP = 1
WALK_LEFT = 2
WALK_RIGHT = 3
WALK_DOWN = 4

class ActiveCHaser < CHaser
  def safe_walk(info, direction)
    # 壁がなければ指定方向へ進む
    case direction
    when WALK_UP
      if info[1] == TYPE_BLOCK
        return false
      end
      return self.walkUp
    when WALK_LEFT
      if info[3] == TYPE_BLOCK
        return false
      end
      return self.walkLeft
    when WALK_RIGHT
      if info[5] == TYPE_BLOCK
        return false
      end
      return self.walkRight
    when WALK_DOWN
      if info[7] == TYPE_BLOCK
        return false
      end
      return self.walkDown
    end
  end

  def run(info)
    if info[1] == TYPE_ENEMY
      self.putUp
    elsif info[3] == TYPE_ENEMY
      self.putLeft
    elsif info[5] == TYPE_ENEMY
      self.putRight
    elsif info[7] == TYPE_ENEMY
      self.putDown
    else
      # ランダムで壁のない方向へ
      # 1: 上, 2: 左, 3: 右, 4: 下
      loop do
        val = rand(4) + 1
        result = self.safe_walk(info, val)
        if result
          break
        end
      end
    end
  end
end
