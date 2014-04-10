require 'colorize'

class Piece
  attr_reader :color
  attr_accessor :position

  def initialize(position, board, player)
    @board = board
    @position = position
    @color = player
  end

  def dup(duped_board)
    self.class.new(@position.dup, duped_board, @color)
  end

  def moves
    movable_directions = all_movable_directions
    possible_moves = collision_check(movable_directions)
    if @board.turn == @color
      return move_into_check(possible_moves)
    else
      return possible_moves
    end
  end

  def move_into_check(possible_moves)
    valid_moves = []

    possible_moves.each do |possible_move|
      duped_board = @board.dup
      duped_piece = duped_board[@position]
      
      duped_board[possible_move] = duped_piece
      duped_board[@position] = nil

      duped_piece.position = possible_move

      valid_moves << possible_move unless duped_board.in_check?(@color)
    end
    return valid_moves
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
    @color == :white ? "\u265C ".colorize(:light_white) : "\u265C ".colorize(:black)
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
    @color == :white ? "\u265D ".colorize(:light_white) : "\u265D ".colorize(:black)
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
    @color == :white ? "\u265B ".colorize(:light_white) : "\u265B ".colorize(:black)
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
    @color == :white ? "\u265A ".colorize(:light_white) : "\u265A ".colorize(:black)
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
    @color == :white ? "\u265E ".colorize(:light_white) : "\u265E ".colorize(:black)
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
    @color == :white ? "\u265F ".colorize(:light_white) : "\u265F ".colorize(:black)
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
      return valid_moves = valid_moves[1..-1]
    end
    if @color == :white && row == 6
      return valid_moves 
    end
    if @color == :black && row == 1
      return valid_moves 
    end

    valid_moves[1..-1]
  end
end

###############################################
class Board
  attr_reader :board, :turn
  def initialize(turn_color = :white)
    @board = Array.new(8) { Array.new(8) }
    @turn = turn_color
  end

  def all_pieces
    @board.flatten.select{ |x| x }
  end

  def []=(position, piece)
    row, col = position
    @board[row][col] = piece
  end

  def [](position)
    row, col = position
    @board[row][col]
  end

  def dup
    duped_board = Board.new(@turn)
    self.all_pieces.each do |piece|
      duped_piece = piece.dup(duped_board)

      duped_board[duped_piece.position] = duped_piece
    end
    duped_board
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
  end

  def render
    system('clear')
    8.times do |row|
      row_str = [8 - row]
      8.times do |col|
        bg = (row + col).even? ? :white : :light_black

        spot = (@board[row][col].nil? ? "  " : @board[row][col].to_s)
        row_str << spot.colorize({ :background => bg })
      end
      puts row_str.join("")
    end
    puts "  #{('a'..'h').to_a.join(" ")}"
  end

  def change_turns
    @turn == :white ? @turn = :black : @turn = :white
  end

  def king_location(color)
    self.all_pieces.select { |piece| piece.class == King && piece.color == color }.first.position
  end

  def in_check?(color)
    color == :white ? (opposite_color = :black) : (opposite_color = :white)
    opposite_color_pieces = self.all_pieces.select { |piece| piece.color == opposite_color }

    enemy_valid_moves = []
    opposite_color_pieces.each do |piece|

      piece.moves.each do |move|
        enemy_valid_moves << move
      end
    end

    enemy_valid_moves.include?(king_location(color))
  end

  def checkmate?(color)
    in_check?(color) && all_pieces.select { |piece| piece.color == color }.all? { |piece| piece.moves.empty? }
  end
end

class Game
  attr_reader :board
  def initialize(board)
    @board = board
    @board.place_pieces
  end

  def run
    until @board.checkmate?(:white) || @board.checkmate?(:black)
        @board.render
        begin
        pos_of_piece, destination = get_input

        move_piece(pos_of_piece, destination)
       
        @board.change_turns
        puts "Check!" if @board.in_check?(@board.turn)

      rescue => e
        puts "Please enter valid move"
        puts e.message
        retry
      end
    end
    puts "Mate!"
  end

  def get_input
    puts "\n#{@board.turn.capitalize}'s move: \nEnter a command...\n"
    input = gets.chomp

    unless input =~ /^[a-h][1-8] [a-h][1-8]$/
      raise "Enter valid format."
    end

    input = input.split(' ')

    start_location, end_location = input.first.split(//), input.last.split(//)

    letter_hash = {
      "a" => 0,
      "b" => 1,
      "c" => 2,
      "d" => 3,
      "e" => 4,
      "f" => 5,
      "g" => 6,
      "h" => 7,
      "1" => 7,
      "2" => 6,
      "3" => 5,
      "4" => 4,
      "5" => 3,
      "6" => 2,
      "7" => 1,
      "8" => 0
    }

    new_start = [letter_hash[start_location.last], letter_hash[start_location.first]]
    new_end = [letter_hash[end_location.last], letter_hash[end_location.first]]

   [new_start, new_end]
  end

  def move_piece(pos_of_piece, destination)
    raise "No piece there" if @board[pos_of_piece].nil?
    moving_piece = @board[pos_of_piece]
    if moving_piece.moves.include?(destination) && moving_piece.color == @board.turn
      moving_piece.position = destination

      @board[destination].position = nil unless @board[destination].nil?

      @board[destination] = moving_piece
      @board[pos_of_piece] = nil

    else
      raise "Invalid move"
    end

  end
end

chess = Game.new(Board.new)
chess.run

