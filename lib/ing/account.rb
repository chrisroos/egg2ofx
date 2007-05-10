module Ing
  class Account
    def initialize(currency, number, sort_code, type = 'SAVINGS')
      @currency, @number, @sort_code, @type = currency, number, sort_code, type
    end
    attr_reader :currency, :number, :sort_code, :type
  end
end