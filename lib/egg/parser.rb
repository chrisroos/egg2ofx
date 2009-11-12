$: << File.dirname(__FILE__)

require 'parsers/document_parser'
require 'parsers/transaction_parser'
require 'parsers/statement_document_parser'
require 'parsers/statement_transaction_parser'
require 'parsers/recent_transactions_document_parser'
require 'parsers/recent_transactions_transaction_parser'

module Egg
  
  class Parser
    
    class UnparsableHtmlError < StandardError; end
    
    def initialize(html)
      if html =~ /your egg card statement/i
        @parser = StatementDocumentParser.new(html)
      elsif html =~ /egg card recent transactions/i
        @parser = RecentTransactionsDocumentParser.new(html)
      else
        raise UnparsableHtmlError
      end
    end
    
    def to_ofx
      @parser.to_ofx
    end
    
  end
  
end