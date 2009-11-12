module Egg
  
  class StatementDocumentParser < DocumentParser
  
  private
  
    def transaction_parser_class
      StatementTransactionParser
    end
    
    def statement_date
      (doc/'#ctl00_content_eggCardStatements_lstPreviousStatements'/'option[@selected=selected]').first.attributes['value']
    end
    
  end
  
end