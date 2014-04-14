require './player'
require 'debugger'

class Game

attr_accessor :game_pot

	def initialize
		@current_bet = 0
		@deck = Deck.new
		@game_pot = 0
		@turn = {true => 1, false => 0}
		@player1 = Player.new(@deck, "Player1")
		@player2 = Player.new(@deck, "Player2")
		@players = [@player1, @player2]
	end

	def play
	puts "\e[H\e[2J"
	puts "Let's play!"
	@deck.shuffle!
	@player1.hand.deal!
	@player2.hand.deal!

	@start = true 

		4.times do |round|
			@start = !@start
			player_turn = @players[@turn[@start]]
			puts "#{player_turn.name}, your cards are:"
			player_turn.display_cards
			
			if round == 2 || round == 3
				player_turn.discard
				player_turn.display_cards
			end

			puts "\n#{player_turn.name}, what's your next action?"
			puts "The current bet is: #{@current_bet}"
			
			action = player_turn.fold_see_or_raise?(@current_bet, @game_pot)

			player_folds(player_turn) if action == 'f'
			player_sees(player_turn) if action == 's'
			
			if action.is_a?(Fixnum) && round == 3
				until !action.is_a?(Fixnum)
					action = player_raises(action, player_turn) 
					action = player_turn.fold_see_or_raise?(@current_bet, @game_pot)
				end
			elsif action.is_a?(Fixnum) && round != 3
					action = player_raises(action, player_turn) 
			end

			puts "\e[H\e[2J"
		end

	showdown
	game_over

	end

	def player_raises(amount, player_turn)
		puts "#{player_turn.name} raised #{amount}"
		@current_bet = amount
		@game_pot += amount 
		puts "game pot is #{game_pot}"
	end

	def showdown
		if @players[0].hand.beats?(@players[1].hand) == true 
			puts "Congratulations #{@players[0].name}, you've won the pot worth #{game_pot}."
			payout(@game_pot, @players[0])
		elsif @players[0].hand.beats?(@players[1].hand) == false
			puts "Congratulations #{@players[0].name}, you've won the pot worth #{game_pot}"
			payout(@game_pot, @players[0])
		else
			puts "Wow!  A Tie!  No payout"
		end
			puts "Player 1 hand:"
			@players[0].display_hand 
			
			puts "Player 2 hand:"
			@players[1].display_hand
	end

	def player_folds(player_turn)
		puts "You folded."
		@start = !@start
		player_turn = @players[@turn[@start]]

		puts "Congratulations #{player_turn.name}, you won the pot worth #{@game_pot}."
		payout(@game_pot, player_turn)
		game_over
	end

	def player_sees(player_turn)
		amount = player_turn.bet(@current_bet)
		@game_pot += amount 
		puts "Updated pot is: #{game_pot}."
		@current_bet = 0
	end

	def game_over
		puts "Play again? y/n"
		answer = gets.chomp.downcase
		if answer == 'y' 
			game = Game.new 
			game.play
		else 
			return nil
		end
	end

	def accept_bet(player, amount, game_pot)
		@game_pot += amount
	end

	def payout(game_pot, player)
		player.win_pot(game_pot)	
	end
end

game = Game.new
game.play
