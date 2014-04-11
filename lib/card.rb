NUMERIC_VALUE_HASH = { :ace => 14,
                       :duece => 2,
                       :three => 3,
                       :four => 4,
                       :five => 5,
                       :six => 6,
                       :seven => 7,
                       :eight => 8,
                       :nine => 9,
                       :ten => 10,
                       :jack => 11,
                       :queen => 12,
                       :king => 13   }




class Card
  attr_reader :suit, :value
  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def numeric_value
    NUMERIC_VALUE_HASH[self.value]
  end
end