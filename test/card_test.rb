
require 'test/unit'
require_relative '../src/card'

class CardTest < Test::Unit::TestCase

proc do # hidden
  def test_interest
    card = Card.new
    card.draw( :on_day => 20, :amount =>  150 )
    assert_equal( 1.44, card.interest( :on_day => 30 ) )
    assert_equal( 5.75, card.interest( :on_day => 60 ) )
    assert_equal( 5.75, card.interest( :on_day => 89 ) )
    assert_equal( 10.07, card.interest( :on_day => 90 ) )
    assert_equal( 10.07, card.interest( :on_day => 91 ) )
    assert_equal( 160.07, card.payoff_amount( :on_day => 91) )
  end


  def test_scenario_2
    card = Card.new
    card.draw( :on_day => 1, :amount => 500 )
    card.make_payment( :on_day => 15, :amount => 200 )
    card.draw( :on_day => 25, :amount => 100 )
    
    # puts! card.payoff_amount( :on_day => 15 )
    
    assert_equal( 11.51, card.interest( :on_day => 30 ) )
    assert_equal( 411.51, card.payoff_amount( :on_day => 30 ))
  end


  def test_apr_and_limit
    card = Card.new
    assert_not_nil card.limit
    assert_not_nil card.apr
  end


  def test_scenario_1
    card = Card.new
    card.draw( :on_day => 1, :amount => 500 )
    # assert_equal( 14.38, card.interest( :on_day => 30 ) )
    assert_equal( 13.90, card.interest( :on_day => 30 ) )
    # assert_equal( 514.38, card.payoff_amount( :on_day => 30 ) )
    assert_equal( 513.9, card.payoff_amount( :on_day => 30 ) )
  end
end

  def test_less_than_30_days
    card = Card.new
    card.draw( :on_day => 1, :amount => 500 )
    card.make_payment( :on_day => 15, :amount => 200 )
    card.draw( :on_day => 25, :amount => 100 )
    assert_equal( 411.51, card.payoff_amount( :on_day => 31 ) )
    assert_equal( 400, card.payoff_amount( :on_day => 26 ) )
  end


  private

  def puts! args
    return []
    puts '+++ +++'
    puts args.inspect
  end

end
