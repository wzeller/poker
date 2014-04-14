require './hand.rb'
require 'debugger'


CARD_SYMBOLS       = { :ace => 'A',
                       :deuce => '2',
                       :three => '3',
                       :four => '4',
                       :five => '5',
                       :six => '6',
                       :seven => '7',
                       :eight => '8',
                       :nine => '9',
                       :ten => '10',
                       :jack => 'J',
                       :queen => 'Q',
                       :king => 'K'   }

CARD_SUITS = {  :diamonds => "\u2666",
                :spades => "\u2660",
                :clubs => "\u2663",
                :hearts => "\u2665"}




class Player
  attr_accessor :pot, :name, :hand
  def initialize(deck, name)
    @hand = Hand.new(deck)
    @pot = 1000
    @name = name
  end

  def discard
    puts "\nPlease select the cards to discard if any (1-5)"
    discard_cards = gets.chomp.split(' ')
    discarded_cards = process_user_input(discard_cards)
    discard_cards_and_redraw!(discarded_cards)
  end

  def deal!
    @hand.deal!
  end

  def display_cards
    @hand.hand.each do |card|
      print "#{CARD_SYMBOLS[card.value]}#{CARD_SUITS[card.suit]} "
    end
  end
  
  def fold_see_or_raise?(bet_amount, game_pot)
    puts "Fold, see, or raise (f, s, r)?"
    action = gets.chomp.downcase
    if action == 'f'
      @hand.return!(@hand.hand)
      puts "You lost the pot"
      return 'f'
    elsif action == 's'
      bet(bet_amount)
      return 's'
    elsif action == 'r'
      puts "How much to raise?"
      raise_pot = gets.chomp.downcase.to_i
      bet(bet_amount+raise_pot.to_i)
      return raise_pot
    end
  end

  def process_user_input(discard_cards)
    #handle errors later
    discard_cards.map! {|input| input.to_i}
    discard_cards.map! {|input| input-1}
    if discard_cards != ""
      discarded_cards = @hand.hand.values_at(*discard_cards)
    else
      discarded_cards = []
    end
    discarded_cards
  end

  def discard_cards_and_redraw!(discarded_cards)

    @hand.return!(discarded_cards)
    @hand.hand += @hand.deck.take!(discarded_cards.length)
  end

  def bet(amount)
    raise "You don't have enough.  Please reenter." if amount > @pot
    @pot -= amount
    amount 
  end

  def win_pot(amount)
    @pot += amount
  end

end



