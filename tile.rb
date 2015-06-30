require_relative "board"
require 'byebug'
require 'set'
require 'colorize'

class Tile
  attr_writer :bombed, :flagged, :revealed
  attr_accessor :pos, :board

  def initialize(pos, board)
    @pos = pos
    @board = board
    @bombed = false
    @flagged = false
    @revealed = false
  end

  def bombed?
    @bombed
  end

  def flagged?
    @flagged
  end

  def revealed?
    @revealed
  end

  def to_s
    if bombed? && revealed?
      "B ".colorize(:red)
    elsif neigh_bomb_count == 0 && revealed?
      "  "
    elsif neigh_bomb_count > 0 && revealed?
      "#{neigh_bomb_count} ".colorize(:yellow)
    elsif flagged?
      "F ".colorize(:green)
    else
      "_ ".colorize(:magenta)
    end
  end

  def reveal
    checked_tiles = Set.new
    queue = [self]

    until queue.empty?
      current_tile = queue.shift
      current_tile.revealed = true
      checked_tiles << current_tile.pos

      current_tile.neighbors.each do |neighbor_pos|
        unless checked_tiles.include?(neighbor_pos) ||
               current_tile.neigh_bomb_count > 0

          queue << board[neighbor_pos]
        end
      end
    end
  end

  def neighbors
    result = []

    [-1, 0 , 1].each do |row_diff|
      [-1, 0, 1].each do |col_diff|
        x, y = pos[0] + row_diff, pos[1] + col_diff
        if x.between?(0, 8) && y.between?(0, 8)
          result << [x, y] unless [row_diff, col_diff] == [0, 0]
        end
      end
    end

    result
  end

  def neigh_bomb_count
    count = 0

    neighbors.each do |neighbor_pos|
      count += 1 if board[neighbor_pos].bombed?
    end

    count
  end
end
