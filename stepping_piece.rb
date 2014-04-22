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
