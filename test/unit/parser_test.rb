require 'test_helper'

module Egg
  class ParserTest < Test::Unit::TestCase
    
    def test_should_instantiate_a_statement_parser_if_the_html_looks_like_a_statement
      html = "Your Egg Card statement"
      StatementParser.expects(:new).with(html)
      paser = Parser.new(html)
    end
    
    def test_should_instantiate_a_recent_transactions_parser_if_the_html_looks_like_it_contains_recent_transactions
      html = "Egg Card Recent transactions"
      RecentTransactionsParser.expects(:new).with(html)
      paser = Parser.new(html)
    end
    
    def test_should_raise_a_malformed_exception_if_it_does_not_look_like_a_statement_or_like_it_contains_recent_transactions
      html = "foo bar baz"
      assert_raise(Egg::Parser::UnparsableHtmlError) { Parser.new(html) }
    end
    
  end
end