require_relative 'base'
require_relative '../const'

class SilentCHaser < CHaser
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
      i = rand(8)
      case i
      when 0
        self.searchLeft
      when 1
        self.searchRight
      when 2
        self.searchUp
      when 3
        self.searchDown
      when 4
        self.lookLeft
      when 5
        self.lookRight
      when 6
        self.lookUp
      else
        self.lookDown
      end
    end
    print 'turn: %d, map size: %d x %d' % [@turn, @map.get_width, @map.get_height]
    print @map.display_text(@position)
  end
end
