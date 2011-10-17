# returns an array of capital percentage relation per odd
class SureBet
  attr_accessor :bets

  def initialize(bets)
    @bets = bets
  end

  def betprize
    # bets contains the multiplier for each possibility
    @bets.inject(:+).to_f
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
    capital.inject(:+)
  end

  def invest(sum = nil)
    if sum.nil?
      min = capital.min
      capital.map { |i| i / min }
    else
      caprisk = capitalrisk
      capital.map { |i| (i * sum) / caprisk }
    end
  end

  def investtotal
    invest.inject(:+)
  end

  def invest_for(earnsum)
    invest(earnsum.to_f / profit)
  end

  def sum_for(earnsum)
    invest_for(earnsum).inject(:+)
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

  def profit(fromsum = nil)
    bp = betprize
    cr = capitalrisk
    pf = (bp / cr) - 1
    fromsum ? fromsum * pf : pf
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
