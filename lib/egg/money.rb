module Egg
  class Money
    def initialize(money)
      money = money.sub(/£/, '').gsub(/,/, '')
      md = money.match(/(\d+\.\d+) ([A-Z]+)/)
      @money = md ? Float(md[1]) : 0
      @money = -@money if md && md[2] == 'DR'
    end
    def to_f
      @money
    end
  end
end