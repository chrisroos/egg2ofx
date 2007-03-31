module Egg
  class Statement
    def initialize(statement_date, closing_balance, account)
      from_date, to_date = statement_date.split(' to ')
      @from_date = Date.build(from_date)
      @to_date = Date.build(to_date)
      @closing_balance = Money.new(closing_balance).to_f
      @account = account
      @transactions = []
    end
    attr_reader :from_date, :to_date, :closing_balance, :transactions
    def add_transaction(transaction)
      transaction.date = from_date unless transaction.date
      @transactions << transaction
    end
    def account_currency
      @account.currency
    end
    def account_number
      @account.number
    end
  end
end