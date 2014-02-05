
require_relative 'base'
require_relative '../const'

class MyCHaser < CHaser
  @@mode = 1
  @@mode_old = 1

  def run(info)
    if @@mode_old == 1
      if info[1] != TYPE_BLOCK
        @@mode = 1
      else
        @@mode = 4
      end
    end

    if @@mode_old == 4 || @@mode == 4
      if info[3] != TYPE_BLOCK
        @@mode = 4
      else
        @@mode = 2
      end
    end

    if @@mode_old == 2 || @@mode ==  4
      if info[7] != 2
        @@mode = 2
      else
        @@mode = 3
      end
    end

    if @@mode_old == 3 || @@mode == 3
      if info[5] != 2
        @@mode = 3
      else
        @@mode = 1
      end
    end

    if info[1] == 3 || info[3] == 3 || info[5] == 3 || info[7] == 3
      if info[1] == 3
        @@mode = 1
      elsif info[3] == 3
        @@mode = 4
      elsif info[5] == 3
        @@mode = 3
      else
        @@mode = 2
      end
    end

    if info[1] == 1 || info[3] == 1 || info[5] == 1 || info[7] == 1
      if info[1] == 1
        @@mode = 5
      elsif info[3] == 1
        @@mode = 8
      elsif info[5] == 1
        @@mode = 7
      else
        @@mode = 6
      end
    end

    if @@mode == 1
      self.walkUp
    elsif @@mode == 2
      self.walkDown
    elsif @@mode == 3
      self.walkRight
    elsif @@mode == 4
      self.walkLeft
    elsif @@mode == 5
      self.putUp
    elsif @@mode == 6
      self.putDown
    elsif @@mode == 7
      self.putRight
    elsif @@mode == 8
      self.putLeft
    end

    @@mode_old = @@mode 
    print @map.display_text(@position)
  end
end
