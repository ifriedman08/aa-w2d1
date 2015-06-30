require_relative "tile"

class Board
  attr_accessor :grid

  def initialize(num)
    @grid = empty_grid
    seed_bombs(num)
  end

  def empty_grid
    grid = Array.new(9) { Array.new(9) }

    grid.each_with_index do |row, x|
      row.each_with_index do |_, y|
        grid[x][y] = Tile.new([x, y], self)
      end
    end

    grid
  end

  def []=(pos, new_val)
    x, y = pos[0], pos[1]
    grid[x][y] = new_val
  end

  def [](pos)
    x, y = pos[0], pos[1]
    grid[x][y]
  end

  def seed_bombs(num)
    bomb_pos = []
    until bomb_pos.length == num
      x = rand(9)
      y = rand(9)
      bomb_pos << [x, y] unless bomb_pos.include?([x, y])
    end

    bomb_pos.each do |b_pos|
      self[b_pos].bombed = true
    end
  end

  def render
    puts "  0 1 2 3 4 5 6 7 8".colorize(:light_blue)
    grid.each_with_index do |row, idx|
      print "#{idx} ".colorize(:light_blue)
      row.each do |tile|
        print tile.to_s
      end
      puts
    end
  end

  def flag_tile(pos)
    self[pos].flagged = true unless self[pos].revealed?
  end
end

if __FILE__ == $PROGRAM_NAME
board = Board.new
board.render
board[[2,2]].reveal

# p board[[2,2]].neighbors
# board.flag_tile([6,3])
#
board.render
end
