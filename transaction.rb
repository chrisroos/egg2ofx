require 'digest/md5'

module Egg
  class Transaction
    def initialize(date, description, money)
      @date = Date.build(date)
      @description = description.squeeze(' ')
      @amount = Money.new(money).to_f
      @ofx_id = nil
    end
    attr_reader :date, :description, :amount
    def ofx_id
      @ofx_id ||= Digest::MD5.hexdigest(to_s)
    end
    def to_s
      [date, description, amount].join(', ')
    end
    def type
      if description =~ /INTEREST/
        'INT'
      else
        (amount < 0) ? 'DEBIT' : 'CREDIT'
      end
    end
  end
end