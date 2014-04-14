require './deck.rb'


HAND_VALUES = [ :royal_flush,
                :straight_flush,
                :four_of_a_kind,
                :full_house,
                :flush,
                :straight,
                :three_of_a_kind,
                :two_pair,
                :pair,
                :high_card]

class Hand
  attr_accessor :hand, :deck, :value_array

  def initialize(deck)
    @hand = []
    @deck = deck
    @value_array = []
  end

  def deal!
    @hand = deck.take!(5)
  end

  def return!(cards)
    @deck.return!(cards)
    @hand -= cards
  end


  def type_of_hand
    return :royal_flush if royal_flush?
    return :straight_flush if straight_flush?
    return :four_of_a_kind if four_of_a_kind?
    return :full_house if full_house?
    return :flush if flush?
    return :staight if straight?
    return :three_of_a_kind if three_of_a_kind?
    return :two_pair if two_pair?
    return :pair if pair?
    return :high_card if high_card?
  end


  def beats?(their_hand)
    our_hand_value = HAND_VALUES.index(self.type_of_hand)
    their_hand_value = HAND_VALUES.index(their_hand.type_of_hand)

    if our_hand_value == their_hand_value
      self.value_array.length.times do |i|
        if self.value_array[i] > their_hand.value_array[i]
          return true
        elsif self.value_array[i] < their_hand.value_array[i]
          return false
        end
      end
      return nil
    else
      our_hand_value < their_hand_value
    end
  end

  def generate_card_multiples
    cards_hash = Hash.new(0)
    @hand.each do |card|
      cards_hash[card.value] += 1
    end
    return cards_hash, cards_hash.values.sort
  end

  def three_of_a_kind?
    cards_hash, card_multiples = generate_card_multiples
    if card_multiples == [1,1,3]
      high_card = NUMERIC_VALUE_HASH[cards_hash.key(3)]
      remaining_cards = @hand.select { |card| card.numeric_value != high_card}
      remaining_cards.map! { |card| card = card.numeric_value}
      remaining_cards.sort!.reverse!
      @value_array = remaining_cards.unshift(high_card)
    else
      false
    end
  end

  def four_of_a_kind?
    cards_hash, card_multiples = generate_card_multiples
    if card_multiples == [1,4]
      high_card = NUMERIC_VALUE_HASH[cards_hash.key(4)]
      remaining_cards = @hand.select { |card| card.numeric_value != high_card}
      remaining_cards.map! { |card| card = card.numeric_value}
      remaining_cards.sort!.reverse!
      @value_array = remaining_cards.unshift(high_card)
    else
      false
    end
  end

  def full_house?
    generate_card_multiples == [2,3]

    cards_hash, card_multiples = generate_card_multiples
    if card_multiples == [2,3]
      high_card = NUMERIC_VALUE_HASH[cards_hash.key(3)]
      remaining_cards = @hand.select { |card| card.numeric_value != high_card}
      remaining_cards.map! { |card| card = card.numeric_value}
      @value_array = remaining_cards = [high_card, remaining_cards[0]]
    else
      false
    end

  end

  def two_pair?
    cards_hash, card_multiples = generate_card_multiples

    if card_multiples == [1,2,2]
      pairs = cards_hash.select{|key, value| value == 2}
      pair_vals = pairs.keys
      pair_hands = @hand.select { |card| pair_vals.include? (card.value)}
      pair_hand_vals = pair_hands.map {|card| card.numeric_value}
      pair_hand_vals.sort!.reverse!
      last_card = @hand.select { |card| !pair_vals.include? (card.value)}
      pair_hand_vals.push(last_card[0].numeric_value)
      @value_array = pair_hand_vals.uniq
    else
      false
    end
  end

  def pair?
    cards_hash, card_multiples = generate_card_multiples
    if card_multiples == [1,1,1,2]
      high_card = NUMERIC_VALUE_HASH[cards_hash.key(2)]
      remaining_cards = @hand.select { |card| card.numeric_value != high_card}
      remaining_cards.map! { |card| card = card.numeric_value}
      remaining_cards.sort!.reverse!
      @value_array = remaining_cards.unshift(high_card)
    else
      false
    end
  end

  def high_card?
    generate_card_multiples == [1,1,1,1,1]
    hand_values = []
      @hand.each do |card|
        hand_values << card.numeric_value
      end
    @value_array = hand_values.sort.reverse
  end

  def high_card
    return [@hand.max_by{|hand| hand.numeric_value}.numeric_value]
  end

  def flush?
    color = @hand[0].suit
    if @hand.all?{|card| card.suit == color}
     @value_array = high_card
    else
      false
    end
  end

  def straight?
    if self.include?(:ace)
      if straight_with_ace?
        @value_array = [4]
        return [4]
      end
    end
    if straight_helper
      @value_array = high_card
      return @value_array
    end
    false
  end

  def straight_with_ace?
    value = straight_helper(true)
    find_ace.numeric_value = 14
    value
  end

  def straight_helper(ace = false)
    if ace
      ace_card = find_ace
      ace_card.numeric_value = 1
    end

    num_values = []

    @hand.each {|card| num_values << card.numeric_value}
    num_values.sort!

    if num_values.last - num_values.first == 4
      return true
    end

    false
  end

  def straight_flush?
    if straight? && flush?
      @value_array = high_card
      return high_card
    end
    false
  end

  def royal_flush?
    straight? && flush? && self.include?(:ace) && self.include?(:king)
  end

  def find_ace
    @hand.each{ |card| return card if card.value == :ace}
  end

  def include?(value)
    @hand.any? { |card| card.value == value}
  end

end

test_hand = Hand.new(Deck.new)
test_hand.deal!
p test_hand.hand