class Piece
  attr_reader :color
  attr_accessor :position

  def initialize(position, board, player)
    @board = board
    @position = position
    @color = player
  end

  def moves
    movable_directions = all_movable_directions
    collision_check(movable_directions)
  end

end

###############################################
class SlidingPiece < Piece
  DELTA = (1..7).to_a

  def collision_check(movable_directions)
    valid_moves = []
    movable_directions.each do |movable_direction|

      movable_direction.each do |destination|
        target_square = @board[destination]

        if target_square.nil?
          valid_moves << destination

        elsif target_square.color != self.color
          valid_moves << destination
          break
        else
          break
        end

      end
    end
    valid_moves
  end
end

class Rook < SlidingPiece
  def to_s
    @color == :white ? "\u2656" : "\u265C"
  end

  def all_movable_directions
    row, col = @position
    down_moves = DELTA.map { |delta| [row + delta, col] }.select { |move| move.first < 8 }
    up_moves = DELTA.map { |delta| [row - delta, col] }.select { |move| move.first >= 0 }
    right_moves = DELTA.map { |delta| [row, col + delta] }.select { |move| move.last < 8 }
    left_moves = DELTA.map { |delta| [row, col - delta] }.select { |move| move.last >= 0 }

    [] << down_moves << up_moves << right_moves << left_moves
  end
end

class Bishop < SlidingPiece
  def to_s
    @color == :white ? "\u2657" : "\u265D"
  end

  def all_movable_directions
    row, col = @position
    downright_moves = DELTA.map { |delta| [row + delta, col + delta] }.select { |move| move.first < 8 && move.last < 8 }
    upleft_moves = DELTA.map { |delta| [row - delta, col- delta] }.select { |move| move.first >= 0 && move.last >= 0 }
    upright_moves = DELTA.map { |delta| [row - delta, col + delta] }.select { |move| move.first >= 0 && move.last < 8 }
    downleft_moves = DELTA.map { |delta| [row + delta, col - delta] }.select { |move| move.first < 8 && move.last >= 0}

    [] << downright_moves << upleft_moves << upright_moves << downleft_moves
  end
end

class Queen < SlidingPiece
  def to_s
    @color == :white ? "\u2655" : "\u265B"
  end

  def all_movable_directions
    row, col = @position
    down_moves = DELTA.map { |delta| [row + delta, col] }.select { |move| move.first < 8 }
    up_moves = DELTA.map { |delta| [row - delta, col] }.select { |move| move.first >= 0 }
    right_moves = DELTA.map { |delta| [row, col + delta] }.select { |move| move.last < 8 }
    left_moves = DELTA.map { |delta| [row, col - delta] }.select { |move| move.last >= 0 }

    downright_moves = DELTA.map { |delta| [row + delta, col + delta] }.select { |move| move.first < 8 && move.last < 8 }
    upleft_moves = DELTA.map { |delta| [row - delta, col- delta] }.select { |move| move.first >= 0 && move.last >= 0 }
    upright_moves = DELTA.map { |delta| [row - delta, col + delta] }.select { |move| move.first >= 0 && move.last < 8 }
    downleft_moves = DELTA.map { |delta| [row + delta, col - delta] }.select { |move| move.first < 8 && move.last >= 0}

    [] << downright_moves << upleft_moves << upright_moves << downleft_moves << down_moves << up_moves << right_moves << left_moves
  end
end

###############################################
class SteppingPiece < Piece

  def collision_check(movable_directions)
    valid_moves = []
    movable_directions.each do |destination|
      target_square = @board[destination]
      if target_square.nil? || target_square.color != self.color
        valid_moves << destination
      end
    end

    valid_moves
  end
end

class King < SteppingPiece
  DELTAS = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

  def to_s
    @color == :white ? "\u2654" : "\u265A"
  end

  def all_movable_directions
    row, col = @position

    movable_spots = DELTAS.map { |delta| [row + delta.first, col + delta.last] }.select do |move|
      move.first >= 0 && move.first < 8 && move.last >= 0 && move.last < 8
    end

    movable_spots
  end
end

class Knight < SteppingPiece
  DELTAS = [[-2, -1], [-2,  1], [-1, -2], [-1,  2], [ 1, -2], [ 1,  2], [ 2, -1], [ 2,  1]]

  def to_s
    @color == :white ? "\u2658" : "\u265E"
  end

  def all_movable_directions
    row, col = @position

    movable_spots = DELTAS.map { |delta| [row + delta.first, col + delta.last] }.select do |move|
      move.first >= 0 && move.first < 8 && move.last >= 0 && move.last < 8
    end

    movable_spots
  end
end

###############################################
class Pawn < Piece
  WHITE_DELTAS = [[-2, 0],[-1, 0], [-1,-1], [-1,1]]
  BLACK_DELTAS = [[2, 0], [1, 0], [1,-1], [1,1]]

  def to_s
    @color == :white ? "\u2659" : "\u265F"
  end

  def all_movable_directions
    row, col = @position
    return WHITE_DELTAS.map {|delta| [delta.first + row, delta.last + col]} if @color == :white

    BLACK_DELTAS.map {|delta| [delta.first + row, delta.last + col]}
  end

  def collision_check(movable_directions)
    row, col = @position

    valid_moves = movable_directions.reject do |movable_direction|
      movable_direction.last != col && (@board[movable_direction].nil? || @board[movable_direction].color == @color)
    end

    if @board[movable_directions[1]] != nil
      valid_moves = valid_moves[2..-1]
      return valid_moves
    elsif @board[movable_directions[0]] != nil
      valid_moves = valid_moves[1..-1]
    end
    if @color == :white && row == 6
      return valid_moves #= valid_moves[1..-1]
    end
    if @color == :black && row == 1
      return valid_moves #= valid_moves[1..-1]
    end

    valid_moves[1..-1]
  end
end

###############################################
class Board
  attr_reader :board
  def initialize
    @board = Array.new(8) { Array.new(8) }

    place_pieces
  end

  def []=(position, piece)
    row, col = position
    @board[row][col] = piece
  end

  def [](position)
    row, col = position
    @board[row][col]
  end

  def place_pieces
    @board[0][0] = Rook.new([0, 0], self, :black)
    @board[0][1] = Knight.new([0, 1], self, :black)
    @board[0][2] = Bishop.new([0, 2], self, :black)
    @board[0][3] = Queen.new([0, 3], self, :black)
    @board[0][4] = King.new([0, 4], self, :black)
    @board[0][5] = Bishop.new([0, 5], self, :black)
    @board[0][6] = Knight.new([0, 6], self, :black)
    @board[0][7] = Rook.new([0, 7], self, :black)

    @board[7][0] = Rook.new([7, 0], self, :white)
    @board[7][1] = Knight.new([7, 1], self, :white)
    @board[7][2] = Bishop.new([7, 2], self, :white)
    @board[7][3] = Queen.new([7, 3], self, :white)
    @board[7][4] = King.new([7, 4], self, :white)
    @board[7][5] = Bishop.new([7, 5], self, :white)
    @board[7][6] = Knight.new([7, 6], self, :white)
    @board[7][7] = Rook.new([7, 7], self, :white)

    8.times do |col|
      @board[1][col] = Pawn.new([1, col], self, :black)
      @board[6][col] = Pawn.new([6, col], self, :white)
    end

    #@board[7][7] = Rook.new([7, 7], @board, :white)
  end

  def render
    puts "  #{(0..7).to_a.join(" ")}"
    8.times do |row|
      row_str = [row]
      8.times do |col|
        row_str << (@board[row][col].nil? ? "_" : @board[row][col].to_s)
      end
      puts row_str.join(" ")
    end
  end
end

class Game
  attr_reader :board
  def initialize(board)
    @turn = :white
    @board = board
  end

  def run
    while true
      begin
        @board.render
        pos_of_piece, destination = get_input

        move_piece(pos_of_piece, destination)
      rescue
        puts "Please enter valid move"
        puts
        retry
      end

    end
  end

  def get_input

    puts "\n#{@turn}'s move.  Enter your command:  'start location', 'end location'. i.e. 0,0 1,0"
    input = gets.chomp.split(' ')
    start_location, end_location = input.first.split(','), input.last.split(',')

    start_location.map! { |coord| Integer(coord) }
    end_location.map! { |coord| Integer(coord) }
    [start_location, end_location]
  end

  def move_piece(pos_of_piece, destination)
    raise "No piece there" if @board[pos_of_piece].nil?
    moving_piece = @board[pos_of_piece]
    if moving_piece.moves.include?(destination) && moving_piece.color == @turn
      moving_piece.position = destination

      @board[destination].position = nil unless @board[destination].nil?

      @board[destination] = moving_piece
      @board[pos_of_piece] = nil

      change_turns
    else
      raise "Invalid move"
    end

  end

  def change_turns
    @turn == :white ? @turn = :black : @turn = :white
  end
end

chess = Game.new(Board.new)
# chess.board[3][0] = Rook.new([3, 0], chess, :white)
# chess.board[2][1] = Rook.new([2, 1], chess, :white)
# chess.board[4][0] = Rook.new([4, 0], chess, :black)
# chess.board[2][2] = Bishop.new([2, 2], chess, :black)
# chess.board[1][1] = Bishop.new([1, 1], chess, :white)
# chess.board[2][1] = Queen.new([2, 1], chess, :white)
# #chess.board[1][2] = King.new([1, 2], chess, :white)
# chess.board[4][3] = Knight.new([4, 3], chess, :black)
# chess.board[1][2] = Pawn.new([1,2], chess, :black)
# chess.board[1][4] = Knight.new([1, 4], chess, :white)
# chess.board[1][3] = Knight.new([1, 3], chess, :white)
chess.run
#p chess.board[1][0].moves
