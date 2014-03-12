require_relative 'base'

class Test2CHaser < CHaser
  # 後攻専用
  # @@mode
  # 1: 下
  # 2: 右
  # 3: 上
  # 4: 左
  @@mode = 1
  def run(info)
    case @@mode
    when 1                     # モードが1のとき
      if info[7] != TYPE_BLOCK # 下が壁でないなら
        info = walkDown        # 下に進む
      else                     # 下が壁なら
        info = walkRight       # 右に進む
        @@mode = 2             # モードを2に
      end
    when 2                     # モードが2のとき
      if info[5] != TYPE_BLOCK # 右が壁でないなら
        info = walkRight       # 右に進む
      else                     # 右が壁なら
        info = walkUp          # 上に進む
        @@mode = 3             # モードを3に
      end
    when 3                     # モードが3のとき
      if info[1] != TYPE_BLOCK # 上が壁でないなら
        info = walkUp          # 上に進む
      else                     # 上が壁なら
        info = walkLeft        # 左に進む
        @@mode = 4             # モードを4に
      end
    when 4                     # モードが4のとき
      if info[3] != TYPE_BLOCK # 左が壁でないなら
        info = walkLeft        # 左に進む
      else                     # 左が壁なら
        info = walkDown        # 下に進む
        @@mode = 1             # モードを1に
      end
    end

    print @map.display_text(@position) # 現段階でのマップを表示
  end
end
