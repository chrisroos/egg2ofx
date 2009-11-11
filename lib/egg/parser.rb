module Egg
  
  class Parser
    
    class UnparsableHtmlError < StandardError; end
    
    def initialize(html)
      if html =~ /your egg card statement/i
        @parser = StatementParser.new(html)
      elsif html =~ /egg card recent transactions/i
        @parser = RecentTransactionsParser.new(html)
      else
        raise UnparsableHtmlError
      end
    end
    
    def to_ofx
      @parser.to_ofx
    end
    
  end
  
end