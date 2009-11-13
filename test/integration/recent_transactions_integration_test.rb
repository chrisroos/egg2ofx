require File.join(File.dirname(__FILE__), '..', 'test_helper')

module Egg
  
  class RecentTransactionsParserIntegrationTest < Test::Unit::TestCase
    
    def setup
      html = File.read(File.join(FIXTURES, 'recent_transactions.html'))
      @ofx = Egg::Parser.new(html).to_ofx
      @xml = Hpricot::XML(@ofx)
    end
    
    def test_should_include_the_xml_processing_instruction
      xml_processing_instruction = @ofx.split("\n")[0] # Should be on the first line
      doc = Hpricot::XML(xml_processing_instruction)
      assert (doc%':eq(0)').xmldecl?
    end
    
    def test_should_include_the_ofx_processing_instruction
      ofx_processing_instruction = @ofx.split("\n")[1] # Should be on the second line
      doc = Hpricot::XML(ofx_processing_instruction)
      assert (doc%':eq(0)').procins?
    end
    
    def test_should_have_the_ofxheader_version_as_the_first_ofx_processing_instruction_attribute_for_wesabe_compatibility
      ofx_processing_instruction = @ofx.split("\n")[1] # Should be on the second line
      assert_match /\?OFX OFXHEADER="200"/, ofx_processing_instruction
    end
    
    def test_should_declare_the_currency_as_gbp
      assert_equal 'GBP', (@xml/:OFX/:CREDITCARDMSGSRSV1/:CCSTMTTRNRS/:CCSTMTRS/:CURDEF).inner_text
    end
    
    def test_should_extract_the_account_number_from_the_html
      assert_equal '1234 4321 1234 4321', (@xml/:OFX/:CREDITCARDMSGSRSV1/:CCSTMTTRNRS/:CCSTMTRS/:CCACCTFROM/:ACCTID).inner_text
    end
    
    def test_should_extract_the_start_date_of_the_transactions_from_the_html
      assert_equal '20091018', (@xml/:OFX/:CREDITCARDMSGSRSV1/:CCSTMTTRNRS/:CCSTMTRS/:BANKTRANLIST/:DTSTART).inner_text
    end
    
    def test_should_extract_the_end_date_of_the_transactions_from_the_html
      assert_equal '20091105', (@xml/:OFX/:CREDITCARDMSGSRSV1/:CCSTMTTRNRS/:CCSTMTRS/:BANKTRANLIST/:DTEND).inner_text
    end
    
    def test_should_contain_the_three_transactions_extracted_from_the_html
      assert_equal 3, (@xml/:OFX/:CREDITCARDMSGSRSV1/:CCSTMTTRNRS/:CCSTMTRS/:BANKTRANLIST/:STMTTRN).length
    end
    
    def test_should_extract_the_first_debit_transaction
      (@xml/:OFX/:CREDITCARDMSGSRSV1/:CCSTMTTRNRS/:CCSTMTRS/:BANKTRANLIST/"STMTTRN:eq(0)").each do |transaction|
        assert_equal 'DEBIT',                            (transaction/:TRNTYPE).inner_text
        assert_equal '20091018',                         (transaction/:DTPOSTED).inner_text
        assert_equal 'EST ANGLIA HGH LDG CR',            (transaction/:NAME).inner_text
        assert_equal 'BRANDON',                          (transaction/:MEMO).inner_text
        assert_equal '-6.4',                            (transaction/:TRNAMT).inner_text
        assert_equal '4c24622f339bfcd2650bf124935225b1', (transaction/:FITID).inner_text
      end
    end
    
    def test_should_extract_the_second_credit_transaction
      (@xml/:OFX/:CREDITCARDMSGSRSV1/:CCSTMTTRNRS/:CCSTMTRS/:BANKTRANLIST/"STMTTRN:eq(1)").each do |transaction|
        assert_equal 'CREDIT',                           (transaction/:TRNTYPE).inner_text
        assert_equal '20091102',                         (transaction/:DTPOSTED).inner_text
        assert_equal 'PAYMENT 2 EGG',                    (transaction/:NAME).inner_text
        assert_equal '.',                                (transaction/:MEMO).inner_text
        assert_equal '71.77',                            (transaction/:TRNAMT).inner_text
        assert_equal 'eecbd3a8bb9789a9af61575d5133fbcd', (transaction/:FITID).inner_text
      end
    end
    
    def test_should_extract_the_third_debit_transaction
      (@xml/:OFX/:CREDITCARDMSGSRSV1/:CCSTMTTRNRS/:CCSTMTRS/:BANKTRANLIST/"STMTTRN:eq(2)").each do |transaction|
        assert_equal 'DEBIT',                            (transaction/:TRNTYPE).inner_text
        assert_equal '20091105',                         (transaction/:DTPOSTED).inner_text
        assert_equal 'LONDON & S E RAIL',                (transaction/:NAME).inner_text
        assert_equal 'LONDON  BRIDG',                    (transaction/:MEMO).inner_text
        assert_equal '-16.65',                           (transaction/:TRNAMT).inner_text
        assert_equal '33c33de7e823d9d1c2f9ea68671e5589', (transaction/:FITID).inner_text
      end
    end
    
    def test_should_extract_the_statement_balance_from_the_html
      assert_equal '-4708.31', (@xml/:OFX/:CREDITCARDMSGSRSV1/:CCSTMTTRNRS/:CCSTMTRS/:LEDGERBAL/:BALAMT).inner_text
    end
    
    def test_should_extract_the_date_of_the_statement_balance_from_the_html
      assert_equal '20091105', (@xml/:OFX/:CREDITCARDMSGSRSV1/:CCSTMTTRNRS/:CCSTMTRS/:LEDGERBAL/:DTASOF).inner_text
    end
  
  end
end