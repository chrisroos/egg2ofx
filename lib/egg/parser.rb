module Egg
  
  class Parser
    
    def initialize(html)
      @parser = if html =~ /\<h1.*?>your egg card statement/i
        StatementParser.new(html)
      else
        RecentTransactionsParser.new(html)
      end
    end
    
    def to_ofx
      @parser.to_ofx
    end
    
  end
  
end