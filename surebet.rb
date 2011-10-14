# returns an array of capital percentage relation per odd
class SureBet
  attr_reader :betmul

  def initialize(betmul)
    @betmul = betmul
  end

  def betprize
    # betmul contains the multiplier for each possibility
    @betmul.inject { |a, mul| a + mul }.to_f
  end

  def betrelation
    total = betprize
    betmul.map { |mul| mul.to_f / total }
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

  def investmap
    min = capital.min
    capital.map { |i| i / min }
  end

  def investtotal
    investmap.inject { |a, i| a + i }
  end

  def earnings
    all = []
    inv = investmap
    invtotal = investtotal
    betmul.each_with_index do |mul, i|
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
