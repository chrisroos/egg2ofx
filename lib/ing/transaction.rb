require 'digest/md5'
require File.expand_path(File.dirname(__FILE__) + '/description')

module Ing
  class Transaction
    def initialize(date, description, money)
      @date = Date.build(date)
      @raw_description = description
      @description = Description.new(description)
      @amount = Money.new(money).to_f
      @ofx_id = nil
    end
    attr_reader :date, :amount
    def payee
      @description.payee
    end
    def note
      @description.note
    end
    def ofx_id
      @ofx_id ||= Digest::MD5.hexdigest(to_s)
    end
    def to_s
      [date, @raw_description, amount].join(', ')
    end
    def type
      if payee =~ /INTEREST/
        'INT'
      else
        (amount < 0) ? 'DEBIT' : 'CREDIT'
      end
    end
  end
end