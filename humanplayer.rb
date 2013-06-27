require './board.rb'
require './piece.rb'

class HumanPlayer
	attr_accessor :pieces, :color, :game 

	def initialize(game, color)
		@game = game
		@color = color.to_sym
		@pieces = 12
	end

	def take_turn
		puts "#{@color} turn"
		puts "Which Piece would you like to move? (0,0)"
		piece = gets.chomp 
		piece = piece.strip.split(",").map {|i| i.to_i}
		#raise "Not yours" unless @game.board[piece[0]][piece[1]].color == @color
		puts "Where would you like to move? (0,0) or 0,0|2,2"
		moves = gets.chomp.split("|")
		moves = moves.map { |move| move.strip.split(",").map {|i| i.to_i}  }
		@game.board[piece[0]][piece[1]].perform_moves(moves)
	end

  def lost?
    true if self.pieces == 0
  end


end