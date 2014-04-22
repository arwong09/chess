require 'colorize'
require_relative 'piece'
require_relative 'stepping_piece'
require_relative 'pawn'
require_relative 'board'
require_relative 'sliding_piece'


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

