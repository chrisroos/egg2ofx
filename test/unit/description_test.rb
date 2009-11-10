require File.join(File.dirname(__FILE__), '..', 'test_helper')

module Egg
  class DescriptionTest < Test::Unit::TestCase
    
    InternalSample = 'MERCHANDISE INTEREST AT 1.313  PER MONTH'
    PurchaseSample = 'PLAY.COM                JERSEY        GB'
    
    def test_should_parse_and_split_into_payee_and_note_and_territory
      description = Description.new(PurchaseSample)
      assert_equal 'PLAY.COM', description.payee
      assert_equal 'JERSEY', description.note
      assert_equal 'GB', description.territory
    end
    
    def test_should_parse_and_leave_content_as_payee
      description = Description.new(InternalSample)
      assert_equal InternalSample, description.payee
    end
    
    def test_should_squeeze_compress_duplicate_spaces
      description = Description.new('PLAY.COM   123          JERSEY        GB')
      assert_equal 'PLAY.COM 123', description.payee
    end
    
  end
end