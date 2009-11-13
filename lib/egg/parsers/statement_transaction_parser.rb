module Egg
  
  class StatementTransactionParser < TransactionParser
  
    def description
      description = super
      if row.next_sibling && (row.next_sibling/"td.date").inner_text == '' && (row.next_sibling/"td.description").inner_text != ''
        description += ' / ' + (row.next_sibling/"td.description").inner_text
      end
      description
    end
  
    def skip?
      date == '' or description == 'OPENING BALANCE'
    end
  
  end
  
end