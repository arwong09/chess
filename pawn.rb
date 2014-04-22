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