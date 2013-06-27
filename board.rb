require './piece.rb'
require './humanplayer.rb'
require 'debugger'
require 'colored'
class Board
	attr_accessor :board, :players

#initialize board with 8x8 squares full of nills

	def initialize
    @board = (0...8).map { [nil] * 8 }
    populate_board

	end

 def run
    @players = [HumanPlayer.new(self, :white), HumanPlayer.new(self, :black)]
    loop do
     
      players.each do |player| 

        begin 
          display
          player.take_turn
        rescue StandardError => e
          puts "#{e.message}"
          retry
        end
      end
    end
  end
 
  def draw_board
  end

  def display
    put_in_notation(chess_chars).each { |row| puts row.join }
  end

  def put_in_notation(array)
    array.each_index { |row| array[row].unshift(8 - row) }
    array.unshift([" "] + (" a ".." h ").to_a)
  end

  def chess_chars
    array = (0...8).map { [nil] * 8 }

    @board.each_index do |row|
      @board[row].each_with_index do |piece,col|
        if (row+col) % 2 == 0
          array[row][col] = colorize(piece, "white")
        else
          array[row][col] = colorize(piece, "black")
        end
      end
    end

    array
  end

  def colorize(piece, background)
    char_hash = {
      Piece => " ♔ ",
      NilClass => "   "
    }

    if piece.nil? || piece.color == :white
      char_hash[piece.class].send("magenta_on_#{background}".to_sym)
    else
      char_hash[piece.class].send("blue_on_#{background}".to_sym)
    end
  end

  def populate_board 
    #debugger
    [0,1,2].each do |num|
      board[num].each_index do |i|
        if num % 2 == 0 && i % 2 == 0
           @board[num][i] = Piece.new(self, :black, [num, i])
       elsif num % 2 != 0 && i % 2 != 0
          @board[num][i] = Piece.new(self, :black, [num, i])
       end
     end
    end

    [5,6,7].each do |num|
      board[num].each_index do |i|
        if num % 2 == 0 && i % 2 == 0
          @board[num][i] = Piece.new(self, :white, [num, i])
        elsif num % 2 != 0 && i % 2 != 0
          @board[num][i] = Piece.new(self, :white, [num, i])
        end
      end
    end
  end


  # def populate_board
  #   debugger
  #   [0,2,6].each do |num|
  #     @board[num].each_index do |i|
  #       if i % 2 == 0
  #         @board[num][i] = Piece.new(self, :black, [num, i]) 
  #       end
  #     end
  #   end 
  #   [1,5,7].each do |num|
  #     @board[num].each_index do |i| 
  #       @board[num][i] = Piece.new(self, :white, [num, i]) if i % 2 != 0
  #     end
  #   end
  #   @board[1].each { |piece| piece.color = :black unless piece.nil? }    
  #   @board[6].each { |piece| piece.color = :white unless piece.nil?}
  # end


  def occupied?(dest)
    return if @board[dest[0]][dest[1]] == nil
    (@board[dest[0]][dest[1]]).color
  end

  def on_board?(dest)
    dest.all?{ |el| el <= 7 && el >= 0 }
  end


end