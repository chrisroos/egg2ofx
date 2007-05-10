module Ing
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
    def method_missing(sym, *args, &blk)
      if account_method = sym.to_s[/^account_(.+)/, 1]
        @account.__send__(account_method, *args, &blk)
      else
        super(sym, *args, &blk)
      end
    end
  end
end