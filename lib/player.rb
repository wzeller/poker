require 'hand'
require 'deck'

card_symbols       = { :ace => 'A',
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

card_suits = {  :diamonds => "\u2666",
                :spades => "\u2660",
                :clubs => "\u2663",
                :hearts => "\u2665"}




class Player
  attr_accessor :hand, :pot
  def initialize
    @hand = Hand.new(Deck.new)
    @pot = 1000
  end

  def discard
    puts "Please select the cards to dicard if any (1-5)"
    discard_cards = gets.chomp.split(' ')
    discard_cards.map! {|input| input.to_i}
    discard_cards.map! {|input| input-1}

    discarded_cards = @hand.values_at(*discard_cards)

    @hand.hand.return!(discarded_cards)

    @hand.deck.take!(discarded_cards.length)
  end

  def display_cards
    @hand.hand.each do |card|
      print "#{card_symbol[card.value]}#{card_suits[card.suit]} "
    end
  end



end