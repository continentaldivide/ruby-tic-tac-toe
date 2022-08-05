# frozen_string_literal: true

class Board
  def initialize
    @player1_win = false
    @player2_win = false
    @draw = false
    @player1_turn = true
    @player2_turn = false
    fetch_player_names
    create_board
    run_game
  end

  def fetch_player_names
    puts 'What\'s player one\'s name?'
    @player1 = gets.chomp
    puts 'What\'s player two\'s name?'
    @player2 = gets.chomp
  end

  def create_board
    @board = [
      ['   ', '|', '   ', '|', '   ', "\n"],
      ['---', '+', '---', '+', '---', "\n"],
      ['   ', '|', '   ', '|', '   ', "\n"],
      ['---', '+', '---', '+', '---', "\n"],
      ['   ', '|', '   ', '|', '   ', "\n"]
    ]
    @key = [
      [' 1 ', '|', ' 2 ', '|', ' 3 ', "\n"],
      ['---', '+', '---', '+', '---', "\n"],
      [' 4 ', '|', ' 5 ', '|', ' 6 ', "\n"],
      ['---', '+', '---', '+', '---', "\n"],
      [' 7 ', '|', ' 8 ', '|', ' 9 ', "\n"]
    ]
  end

  def run_game
    until (@player1_win == true) || (@player2_win == true) || (@draw == true)
      play_turn
      check_if_end
      switch_player
    end
    if @player1_win == true
      puts 'player 1 win'
    elsif @player2_win == true
      puts 'player 2 win'
    elsif @draw == true
      puts 'draw'
    end
  end

  private

  def play_turn
    player_turn_instructions
    player_move = player_turn_options
    draw_move(player_move)
    show_board
  end

  def player_turn_instructions
    puts "\n"
    puts "#{@player1}'s turn!" if @player1_turn == true
    puts "#{@player2}'s turn!" if @player2_turn == true
    puts 'Options:'
    puts 'Enter a number 1-9 to play.'
    puts 'Enter \'key\' to see which number corresponds to which square.'
    puts 'Enter \'board\' to see the current board.'
  end

  def player_turn_options
    exit_loop = false
    while exit_loop == false
      input = validate_input(gets.chomp)
      case input
      when 'board'
        show_board
      when 'key'
        show_key
      else
        exit_loop = true
      end
    end
    input
  end

  def validate_input(input)
    valid_inputs = %w[key board 1 2 3 4 5 6 7 8 9]
    until valid_inputs.include?(input)
      puts 'invalid input.'
      input = gets.chomp
    end
    input
  end

  def show_board
    display_board = @board.join
    puts display_board
  end

  def show_key
    display_board = @key.join
    puts display_board
  end

  def draw_move(number)
    location = translate_input(number)
    @board[location[0]][location[1]] = ' X ' if @player1_turn == true
    @board[location[0]][location[1]] = ' O ' if @player2_turn == true
  end

  def translate_input(number)
    @board_translator = {
      '1' => [0, 0],
      '2' => [0, 2],
      '3' => [0, 4],
      '4' => [2, 0],
      '5' => [2, 2],
      '6' => [2, 4],
      '7' => [4, 0],
      '8' => [4, 2],
      '9' => [4, 4]
    }
    @board_translator[number]
  end

  def switch_player
    @player1_turn = @player1_turn.!
    @player2_turn = @player2_turn.!
  end

  def check_if_end
    player1_win_string = ' X  X  X '
    player2_win_string = ' O  O  O '
    @win_lines = [
      @board[0][0] + @board[0][2] + @board[0][4], # top row
      @board[2][0] + @board[2][2] + @board[2][4], # middle row
      @board[4][0] + @board[4][2] + @board[4][4], # bottom row
      @board[0][0] + @board[2][0] + @board[4][0], # left column
      @board[0][2] + @board[2][2] + @board[4][2], # middle column
      @board[0][4] + @board[2][4] + @board[4][4], # right column
      @board[0][0] + @board[2][2] + @board[4][4], # TL -> BR diag
      @board[0][4] + @board[2][2] + @board[4][0] # TR -> BL diag
    ]
    @player1_win = true if @win_lines.include?(player1_win_string)
    @player2_win = true if @win_lines.include?(player2_win_string)
    @draw = true unless @board.flatten.include?('   ')
  end
end

board = Board.new
