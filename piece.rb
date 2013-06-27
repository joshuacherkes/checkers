require 'debugger'
require './board.rb'
require './humanplayer.rb'

class Piece
    attr_accessor :game, :color, :pos, :is_king 



    def initialize(game, color, pos, is_king = false)
      @game = game
      @is_king = is_king
      @color = color.to_sym
      @pos = pos 
    end

    def perform_slide(dest)
      unless slide_moves.include?(dest)
        raise InvalidMoveError, "That is an invalid slide" 
      end
      @game.board[dest[0]][dest[1]] = self
      @game.board[@pos[0]][@pos[1]] = nil
      @pos[0], pos[1] = dest[0], dest[1]
      
    end


    def perform_jump(dest)
      debugger
      unless jump_moves.include?(jump_pos)
        #raise InvalidMoveError, "That is an invalid jump"
      end
      jump_diff = [
        (jump_pos[0] - @pos[0]) / 2,
        (jump_pos[1] - @pos[1]) / 2
      ]
      jumped_pos = [
        pos[0] + jump_diff[0],
        pos[1] + jump_diff[1]
      ]
      @game.board[dest[0]][dest[1]] = self
      @game.board[@pos[0]][@pos[1]] = nil
      subtract_jumped_piece([in_between[0]+dest[0], in_between[1]+dest[1]])
      @game.board[jumped_pos[0]][jump_pos[1]] = nil
      @pos[0], pos[1] = dest[0], dest[1]
    end




    def subtract_jumped_piece(piece)
      if @game.board[piece[0]][piece[1]].color == :black
        @game.players[1].pieces -= 1
      elsif @game.board[piece[0]][piece[1]].color == :white
        @game.players[0].pieces -= 1
      end
    end

    def valid_move_seq?(moves)
      game = @game.dup
      begin
        perform_moves!(moves)
      rescue 
        @game = game 
        false
      else
        @game = game
        true
      end
    end

    def perform_moves(moves)
      raise InvalidMoveError, "invalid moves" unless valid_move_seq?(moves)
      perform_moves!(moves)
    end


    def perform_moves!(moves)
      if slide_moves.include?(moves[0])
        perform_slide(moves[0])
      elsif jump_moves.include?(moves[0])
        moves.each do |move|
          perform_jump(move)
        end
      end 
    end
      

    def moves
      slide_moves + jump_moves
    end

    def delta_pawn
      if is_king
        return  [[1, 1], [1,-1], [-1, 1], [-1,-1]]
      end
      case @color
      when :black
          [[1, 1],[1,-1]]
      when :white
          [[-1, 1],[-1,-1]]
      end
    end

    def jump_delta
      delta_pawn.map {|delta| delta.map { |el| el * 2} }
    end


    def slide_moves
      array = []
      deltas = delta_pawn
      deltas.each do |delta| 
        dest = [@pos[0] + delta[0], @pos[1] + delta[1]]
        array << dest if valid_slide?(dest)
      end
      array
    end  

    def valid_slide?(dest)
      return if @game.occupied?(dest)
      return unless @game.on_board?(dest)
      return true if delta_pawn.include?([dest[0] - @pos[0], dest[1] - @pos[1]])
    end

    def jump_moves
      array = []
      deltas = jump_delta
      deltas.each do |delta| 
        dest = [@pos[0] + delta[0], @pos[1] + delta[1]]
        array << dest if valid_jump?(dest)
      end
      array

    end
    #There are problems with this method, plan on fixing later tonight
    def valid_jump?(dest)
      debugger
      jump_diff = [
        (dest[0] - @pos[0]) / 2,
        (dest[1] - @pos[1]) / 2
      ]
      jumped_pos = [
        pos[0] + jump_diff[0],
        pos[1] + jump_diff[1]
      ]
      return if @game.occupied?(dest)
      return unless @game.on_board?(dest)
      if self.color == :black 
        piece_to_jump = @game.occupied?(jumped_pos)
      else
        piece_to_jump = @game.occupied?(jumped_pos)
      end
      case piece_to_jump
      when self.color
        false
      when nil 
        false 
      else
        true
      end
    end 

end


class InvalidMoveError < StandardError
end