require_relative 'active'

# HogeCHaserの部分を自分の好きなように書き換える
# ただし，頭文字は大文字
class HogeCHaser < ActiveCHaser
  #---ユーザ定義関数---

  #--------------------
  def run(info)
    # 実際に動かす部分
    # 1ターン分の処理を書き込む
    # getReadyは別の部分で行なっているため書かない．
    # info に周囲情報が含まれている．
    # サーバ情報を含まないので左上が0から始まる．
  end
end
