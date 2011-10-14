# returns an array of capital percentage relation per odd
class SureBet
  attr_accessor :bets

  def initialize(bets)
    @bets = bets
  end

  def betprize
    # bets contains the multiplier for each possibility
    @bets.inject { |a, mul| a + mul }.to_f
  end

  def betrelation
    total = betprize
    bets.map { |mul| mul.to_f / total }
  end

  # this gives the capital needed to cover the bet
  # in other words, if the sum of all the capital inversion is greater than
  # the sum of all the bet multipliers, this is not a sure bet.
  def capital
    betrel = betrelation
    betrel.map { |mul| 1.0 / mul }
  end

  def capitalrisk
    capital.inject { |a, i| a + i }
  end

  def invest
    min = capital.min
    capital.map { |i| i / min }
  end

  def investtotal
    invest.inject { |a, i| a + i }
  end

  def earnings
    all = []
    inv = invest
    invtotal = investtotal
    bets.each_with_index do |mul, i|
      all << mul * inv[i] - invtotal
    end
    all
  end

  def profit
    (betprize / capitalrisk) - 1
  end

  def profit_s
    "#{profit * 100}%"
  end

  def surebet?
    #earnings.all? do |e|
    #  e >= 0.0
    #end
    betprize > capitalrisk
  end

  def winloss
    betprize - capitalrisk
  end
end
