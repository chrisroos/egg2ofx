module Egg
  
  class RecentTransactionsTransactionParser < TransactionParser
    
    def money
      money = (row/"td.money").inner_text.sub(/^\?/, '')
      # Amounts in recent transactions are represented differently (-1 and 1 vs 1 CR and 1 DR)
      if money =~ /^\-/
        money << ' CR'
      else
        money << ' DR'
      end
    end
    
  end
  
end