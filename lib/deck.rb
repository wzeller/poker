require "card.rb"

class Deck
  attr_accessor :cards

  def initialize
    @cards = Deck.new_deck
  end

  def self.new_deck
    suits = [ :hearts, :spades, :diamonds, :clubs]
    values = [ :ace, :duece, :three, :four, :five, :six, :seven,
              :eight, :nine, :ten, :jack, :queen, :king ]
    [].tap do |cards|
      suits.each do |suit|
        values.each do |value|
          cards << Card.new(suit, value)
        end
      end
    end
  end

  def shuffle!
    @cards.shuffle!
  end

  def take!(num)
    [].tap do |given_cards|
      num.times { given_cards << @cards.shift }
    end
  end

  def return!(cards)
    cards.each do |card|
      @cards.push card
    end
  end

end