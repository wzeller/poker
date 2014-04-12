require 'spec_helper'
require 'card'



describe Card do
  subject(:new_card){ Card.new(:diamonds, :deuce) }

  it 'should have a value that can be accessed' do
    expect(new_card.numeric_value).to eq(2)
  end

  it 'should have a :duece value' do
    expect(new_card.value).to eq(:deuce)
  end

  it 'should have a suit' do
    expect(new_card.suit).to eq(:diamonds)
  end

end
