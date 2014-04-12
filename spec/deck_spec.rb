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
      unshuffled = subject.cards.dup
      expect(unshuffled).to eq(my_deck.cards)

      my_deck.shuffle!
      expect(unshuffled).to_not eq(my_deck.cards)
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

  describe '#return' do

    it 'should return 2 cards after taking them' do
      two_cards = my_deck.take!(2)
      my_deck.return!(two_cards)
      expect(my_deck.cards.length).to eq(52)
    end
  end



end