require './piece.rb'
# REV=> like Jonathan said, can use require_relative
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
    # REV=> maybe players should be assigned in the initialize method?
    @players = [HumanPlayer.new(self, :white), HumanPlayer.new(self, :black)]
    loop do
     
      players.each do |player| 

        begin 
          display
          player.take_turn
        rescue StandardError => e
          # REV=> don't need to interpolate neccessarily
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
    # REV=> (" a ".." h ").to_a) == Array(" a ".." h ")
    array.unshift([" "] + (" a ".." h ").to_a)
  end

  def chess_chars
    # REV=> same as: Array.new(8){ Array.new(8) {nil} }
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
    # REV=> This should be in your piece class, and it could also
    # REV=> be done in a to_s method within the piece class, so that 
    # REV=> when you call "puts" you will automatically format it 
    # REV=> since "puts" calls "to_s"
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
          # REV=> note that since you've already used attr_accessor
          # REV=> on the instance variable "board," you no longer
          # REV=> need to reference it with the @ symbol
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
    # REV=> methods with a question mark should be returning
    # REV=> true and false only, like you have in the method 
    # REV=> on_board? below
    return if @board[dest[0]][dest[1]] == nil
    (@board[dest[0]][dest[1]]).color
  end

  def on_board?(dest)
    # REV=> more concise as: el.between?(0,7)
    dest.all?{ |el| el <= 7 && el >= 0 }
  end


end