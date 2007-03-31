module Egg
  class Account
    def initialize(currency, number)
      @currency, @number = currency, number
    end
    attr_reader :currency, :number
  end
end