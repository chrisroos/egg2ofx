module Ing
  class Money
    def initialize(money)
      @money = money.to_f
    end
    def to_f
      @money
    end
  end
end