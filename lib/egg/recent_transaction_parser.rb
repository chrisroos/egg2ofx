module Egg
  
  class RecentTransactionsParser < DocumentParser

  private
  
    def transaction_parser_class
      RecentTransactionsTransactionParser
    end
    
    def statement_date
      first_transaction_date = (doc/'#tblTransactionsTable'/'tbody'/'tr'/'td.date').first.inner_text
      last_transaction_date = (doc/'#tblTransactionsTable'/'tbody'/'tr'/'td.date').last.inner_text
      "#{first_transaction_date} to #{last_transaction_date}"
    end

  end
  
end