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