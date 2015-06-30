require_relative 'board'

class MinesweeperGame

attr_accessor :board, :lost
attr_reader :bomb_bum

  def initialize(bombs)
    @bomb_num = bombs
    @board = Board.new(bombs)
    @grid = board.grid
    @lost = false
  end

  def play
    until game_over
      system('clear')
      board.render
      play_turn
    end
    board.render
  end

  def play_turn
    print "Enter row: > "
    row = gets.chomp.to_i
    print "Enter column: > "
    col = gets.chomp.to_i
    print "Revealing, flagging, or saving (r/f/s)?: > "
    action = gets.chomp.downcase

    if action == "s"
      game_state = self.to_yaml
      print "Enter save file name: "
      file_name = gets.chomp
      File.open(file_name, 'w'){|file| file.write(game_state)}
    elsif action == "r" && !board[[row, col]].bombed?
      board[[row, col]].reveal
    elsif action == "r" && board[[row, col]].bombed?
      board[[row, col]].reveal
      lose
    else action == "f"
      board[[row, col]].flagged = !board[[row, col]].flagged?
    end
  end

  def game_over
    win? || lost
  end

  def win?
    flag_count = 0
    revealed_count = 0
    @grid.each do |row|
      row.each do |tile|
        flag_count += 1 if tile.flagged? && !tile.revealed?
        revealed_count += 1 if tile.revealed? #&& !tile.flagged?
      end
    end

    return flag_count + revealed_count == 81
  end

  def lose
    self.lost = true
    puts "YOU LOSE!!!!!!!!!!!!!!".colorize(:red)
  end


end

if __FILE__ == $PROGRAM_NAME
  puts "New game or open saved game (n/o)?: > "
  if gets.chomp.downcase == "o"
    puts "Enter name of file: > "
    file_name = gets.chomp

    saved_game = YAML::load(File.open(file_name))
    saved_game.play
  else
    puts "How many bombs?"
    bomb_nums = gets.chomp.to_i

    game = MinesweeperGame.new(bomb_nums)
    game.play
  end
end
