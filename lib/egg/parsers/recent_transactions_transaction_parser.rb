module Egg
  
  class RecentTransactionsTransactionParser < TransactionParser
    
    def money
      money = super
      money =~ /^\-/ ? money + ' CR' : money + ' DR'
    end
    
  end
  
end