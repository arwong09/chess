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
