require 'deck'
require 'card'
require 'spec_helper'

describe Deck do
  subject(:my_deck) { Deck.new }

  describe '#cards' do


    it 'should have 52 different cards on initialize' do
      expect(my_deck.cards.uniq.length).to eq(52)
    end

    it 'should shuffle the cards' do
      other_deck = Deck.new
      my_deck.shuffle!

      expect(other_deck.cards).to_not eq(my_deck.cards)
    end

  end

  describe '#take' do

    it 'should deal out two new cards' do
      expect(my_deck.cards[0..1]).to eq(my_deck.take!(2))
    end

    it 'should have 48 cards after taking four' do
      my_deck.take!(4)
      expect(my_deck.cards.count).to eq(48)
    end
  end
end