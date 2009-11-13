require 'test_helper'

module Ofx
  class OfxTest < Test::Unit::TestCase
    
    def test_should_have_the_ofxheader_version_as_the_first_ofx_processing_instruction_attribute_for_wesabe_compatibility
      account   = Egg::Account.new('GBP', 'account number')
      statement = Egg::Statement.new('01 Jan 2009 to 01 Jan 2009', '0', account)
      ofx       = Statement.new(statement).to_xml

      assert_match /\?OFX OFXHEADER="200"/, ofx
    end
    
  end
end