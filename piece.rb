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
