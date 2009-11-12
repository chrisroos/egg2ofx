module Egg
  
  class DocumentParser
    
    attr_reader :doc
    
    def initialize(html)
      @doc = Hpricot(html)
    end
    
    def to_ofx
      account   = Egg::Account.new('GBP', card_number)
      statement = Egg::Statement.new(statement_date, closing_balance, account)
      
      each_transaction do |transaction_row|
        next if transaction_row.skip?
        transaction = Egg::Transaction.new(transaction_row.date, transaction_row.description, transaction_row.money)
        statement.add_transaction(transaction)
      end

      Ofx::Statement.new(statement).to_xml
    end
    
  private
  
    def each_transaction
      (doc/"table#tblTransactionsTable"/"tbody"/"tr").each do |row|
        yield transaction_parser_class.new(row)
      end
    end
    
    def card_number
      (doc/"span#lblCardNumber").inner_html
    end
    
    def closing_balance
      ((doc/"table#tblTransactionsTable"/"tfoot"/"tr").first/"td").inner_html
    end
    
  end
  
end