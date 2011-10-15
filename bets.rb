class Bets
  attr_reader :desc, :bets

  def initialize(desc = 'Unnamed bet')
    @desc = desc
    @bets = {}
  end

  def betsize
    bets.values.first.size
  end

  def add(web, bet)
    unless bets.empty?
      raise "Bet size must match already entered bets" unless betsize == bet.size
    end
    @bets[web] = bet.map do |b|
      b ? b : 0
    end
  end

  def max_by_web
    maxbets = Array.new betsize, bets.keys.first
    bets.each do |w, b|
      b.each_with_index do |q, i|
        maxbets[i] = w if q > bets[maxbets[i]][i]
      end
    end
    maxbets
  end

  def max
    maxbets = Array.new betsize, 0
    bets.each do |w, b|
      b.each_with_index do |q, i|
        maxbets[i] = q if q > maxbets[i]
      end
    end
    maxbets
  end
end
