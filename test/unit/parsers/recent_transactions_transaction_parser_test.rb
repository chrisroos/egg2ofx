require 'test_helper'

module Egg
  class RecentTransactionsTransactionParserTest < Test::Unit::TestCase
    
    def test_should_deal_with_html_encoded_pound_sign
      html   = '<tr><td class="money">&pound;9.79</td></tr>'
      doc    = Hpricot(html)
      parser = RecentTransactionsTransactionParser.new(doc)
      
      assert_equal '9.79 DR', parser.money
    end
    
    def test_should_deal_with_html_decoded_pound_sign
      html   = '<tr><td class="money">£9.79</td></tr>'
      doc    = Hpricot(html)
      parser = RecentTransactionsTransactionParser.new(doc)
      
      assert_equal '9.79 DR', parser.money
    end
    
  end
end