module Egg
  
  class TransactionParser
  
    attr_reader :row
  
    def initialize(row)
      @row = row
    end
  
    def skip?
      false
    end
    
    def money
      (row/"td.money").inner_text.sub(/^\?/, '').sub(/^£/, '')
    end
  
    def date
      (row/"td.date").inner_text
    end
  
    def description
      (row/"td.description").inner_text
    end
  
  end
  
end