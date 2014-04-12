require 'hand'
require 'spec_helper'


describe Hand do
  subject(:test_hand) { Hand.new(Deck.new) }


  describe '#initialize' do
    it 'initializes with an empty hand' do
      expect(test_hand.hand.length).to eq(0)
    end
  end


  describe '#deal!' do
    it 'accepts 5 cards objects and adds them to the hand' do
      test_hand.deal!
      expect(test_hand.hand.length).to eq(5)
    end
  end

  describe '#return!' do
    it 'returns the cards picked from the hand to the deck' do
      test_hand.deal!
      test_hand.return!(test_hand.hand[0..2])
      expect(test_hand.hand.length).to eq(2)
    end


    it 'actually returns cards into the deck' do
      test_hand.deal!
      test_hand.return!(test_hand.hand[0..2])
      expect(test_hand.deck.cards.length).to eq(50)
    end

  end


  describe '#royal_flush?' do

    it 'returns true when hand contains royal flush' do
      test_hand.hand                               = [
        Card.new(:hearts,  :ace),
        Card.new(:hearts,  :king),
        Card.new(:hearts,  :queen),
        Card.new(:hearts,  :jack),
        Card.new(:hearts,  :ten) ]


        expect(test_hand.royal_flush?).to be true
      end

      it 'returns false when hand doesn\'t contains royal flush' do
        test_hand.hand                               = [
          Card.new(:hearts,  :eight),
          Card.new(:hearts,  :king),
          Card.new(:hearts,  :queen),
          Card.new(:hearts,  :jack),
          Card.new(:hearts,  :ten) ]
          expect(test_hand.royal_flush?).to be false
        end
      end



      describe '#flush?' do
        it 'returns true if a hand is a flush' do
          test_hand.hand                               = [].tap {|hand| 5.times {|card| hand <<                                          Card.new(:hearts,  :deuce)}}
          expect(test_hand.flush?).to be true
        end

        it 'returns false if a hand is not a flush' do
          test_hand.hand                               = [].tap {|hand| 4.times {|card| hand <<                                          Card.new(:hearts,  :deuce)} }

          test_hand.hand << Card.new(:spades,  :ace)

          expect(test_hand.flush?).to be false
        end
      end

      describe '#straight?' do
        it 'returns true if a hand is a straight' do
          test_hand.hand                               = [].tap{|hand| 5.times {|i| hand <<                                          Card.new(:hearts,  :deuce)}}

          5.times {|i| test_hand.hand[i].numeric_value = i }

          expect(test_hand.straight?).to be true
        end

        it 'returns false if a hand isn\'t a straight' do
          test_hand.hand                               = [].tap {|hand| 5.times {|card| hand <<                                          Card.new(:hearts,  :deuce)}}

          expect(test_hand.straight?).to be false
        end

        it 'should return true as ace as low card' do
          test_hand.hand                               = [
            Card.new(:hearts,  :ace),
            Card.new(:hearts,  :deuce),
            Card.new(:hearts,  :four),
            Card.new(:hearts,  :three),
            Card.new(:hearts,  :five) ]

            expect(test_hand.straight?).to be true
            expect(test_hand.find_ace.numeric_value).to eq(14)
          end


        end

        describe '#four_of_a_kind?' do
          it 'returns true when hand contains 4 of a kind.' do
            test_hand.hand                               = [].tap{|hand| 4.times {|i| hand <<                                        Card.new(:hearts,:deuce)}}
            test_hand.hand << Card.new(:spades, :ace)

            expect(test_hand.four_of_a_kind?).to eq([2,14])
          end

          it 'returns false when hand doesn\'t contain 4 of a kind' do
            test_hand.hand                               = [
              Card.new(:hearts,  :ace),
              Card.new(:hearts,  :deuce),
              Card.new(:hearts,  :four),
              Card.new(:hearts,  :three),
              Card.new(:hearts,  :five) ]

              expect(test_hand.four_of_a_kind?).to be false
            end

          end


          describe '#three_of_a_kind?' do
            it 'returns true when a hand contains 3 of a kind' do
              test_hand.hand = [].tap{|hand| 3.times {|i| hand <<                                               Card.new(:hearts,  :deuce)}}
              test_hand.hand += [Card.new(:spades, :ace), Card.new(:spades,                                     :three)]

              expect(test_hand.three_of_a_kind?).to eq([2,14,3])
            end
          end

          describe '#two_pair?' do
            it 'returns true if a hand has two pair' do
              test_hand.hand = [Card.new(:hearts,  :deuce),
                Card.new(:hearts,  :deuce),
                Card.new(:hearts,  :three),
                Card.new(:hearts,  :three),
                Card.new(:hearts,  :four)]

                expect(test_hand.two_pair?).to eq([3,2,4])
              end
            end

            describe "#pair?" do
              it 'returns true if a hand has a pair' do
                test_hand.hand = [Card.new(:hearts,  :deuce),
                Card.new(:hearts,  :deuce),
                Card.new(:hearts,  :three),
                Card.new(:hearts,  :five),
                Card.new(:hearts,  :four)]

                expect(test_hand.pair?).to eq([2,5,4,3])
              end
            end


            describe "#high_card?" do
              it 'returns sorted array of the cards' do
                test_hand.hand = [Card.new(:hearts,  :deuce),
                Card.new(:hearts,  :six),
                Card.new(:hearts,  :three),
                Card.new(:hearts,  :five),
                Card.new(:hearts,  :four)]

                expect(test_hand.high_card?).to eq([6,5,4,3,2])
              end
            end

            describe '#generate_card_multiples' do
              it 'returns a sorted list of values ' do

                test_hand.hand = [Card.new(:hearts,  :deuce),
                Card.new(:hearts,  :six),
                Card.new(:hearts,  :three),
                Card.new(:hearts,  :three),
                Card.new(:hearts,  :four)]

                expect(test_hand.generate_card_multiples).to eq([{:deuce =>1, :six =>1, :three=>2, :four=>1}, [1,1,1,2]])
              end
            end

            describe '#full_house?' do
              it 'should return true for full house' do
                test_hand.hand = [Card.new(:hearts,  :deuce),
                Card.new(:hearts,  :deuce),
                Card.new(:hearts,  :three),
                Card.new(:hearts,  :three),
                Card.new(:hearts,  :three)]
                expect(test_hand.full_house?).to eq([3,2])
              end
            end







        describe '#eval_hand' do
        it 'should generate a higher number for full house than 3 of a kind' do
          test_hand.hand = [Card.new(:hearts,  :ace),
          Card.new(:hearts,  :ace),
          Card.new(:hearts,  :king),
          Card.new(:hearts,  :king),
          Card.new(:hearts,  :king)]




          other_hand = Hand.new(Deck.new)
          other_hand.hand = [Card.new(:hearts,  :deuce),
          Card.new(:hearts,  :deuce),
          Card.new(:hearts,  :three),
          Card.new(:hearts,  :three),
          Card.new(:hearts,  :three)]

          expect(test_hand.eval_hand).to be < other_hand.eval_hand
          end


          it '3 of a kind with king beats 3of kind with 3' do

            test_hand.hand = [Card.new(:hearts,  :ace),
            Card.new(:hearts,  :deuce),
            Card.new(:hearts,  :king),
            Card.new(:hearts,  :king),
            Card.new(:hearts,  :king)]
            other_hand = Hand.new(Deck.new)

            other_hand.hand = [Card.new(:hearts,  :four),
            Card.new(:hearts,  :deuce),
            Card.new(:hearts,  :three),
            Card.new(:hearts,  :three),
            Card.new(:hearts,  :three)]

            expect(test_hand.eval_hand).to be > other_hand.eval_hand
          end
        end









        end #FIRST DESCRIBE END
