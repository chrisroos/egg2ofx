require 'test/unit'
require 'rubygems'
require 'hpricot'
require File.join(File.dirname(__FILE__), '..', 'lib', 'egg')
require File.join(File.dirname(__FILE__), '..', 'lib', 'ofx')

module Egg
  
  class StatmentParserIntegrationTest < Test::Unit::TestCase
  
    FIXTURES = File.join(File.dirname(__FILE__), 'fixtures')
    
    def setup
      html = File.read(File.join(FIXTURES, 'statement.html'))
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
    
    def test_should_declare_the_currency_as_gbp
      assert_equal 'GBP', (@xml/:OFX/:CREDITCARDMSGSRSV1/:CCSTMTTRNRS/:CCSTMTRS/:CURDEF).inner_text
    end
    
    def test_should_extract_the_account_number_from_the_html
      assert_equal '1234 4321 1234 4321', (@xml/:OFX/:CREDITCARDMSGSRSV1/:CCSTMTTRNRS/:CCSTMTRS/:CCACCTFROM/:ACCTID).inner_text
    end
    
    def test_should_extract_the_start_date_of_the_transactions_from_the_html
      assert_equal '20090718', (@xml/:OFX/:CREDITCARDMSGSRSV1/:CCSTMTTRNRS/:CCSTMTRS/:BANKTRANLIST/:DTSTART).inner_text
    end
    
    def test_should_extract_the_end_date_of_the_transactions_from_the_html
      assert_equal '20090818', (@xml/:OFX/:CREDITCARDMSGSRSV1/:CCSTMTTRNRS/:CCSTMTRS/:BANKTRANLIST/:DTEND).inner_text
    end
    
    def test_should_contain_the_four_transactions_extracted_from_the_html
      assert_equal 4, (@xml/:OFX/:CREDITCARDMSGSRSV1/:CCSTMTTRNRS/:CCSTMTRS/:BANKTRANLIST/:STMTTRN).length
    end
    
    def test_should_extract_the_first_debit_transaction
      (@xml/:OFX/:CREDITCARDMSGSRSV1/:CCSTMTTRNRS/:CCSTMTRS/:BANKTRANLIST/"STMTTRN:eq(0)").each do |transaction|
        assert_equal 'DEBIT',                            (transaction/:TRNTYPE).inner_text
        assert_equal '20090720',                         (transaction/:DTPOSTED).inner_text
        assert_equal 'LONDON S E RAIL',                  (transaction/:NAME).inner_text
        assert_equal 'RAMSGATE   SS',                    (transaction/:MEMO).inner_text
        assert_equal '-87.5',                            (transaction/:TRNAMT).inner_text
        assert_equal 'aff05b64c9f603848051ba9afe8ff666', (transaction/:FITID).inner_text
      end
    end
    
    def test_should_extract_the_second_multiline_debit_transaction
      (@xml/:OFX/:CREDITCARDMSGSRSV1/:CCSTMTTRNRS/:CCSTMTRS/:BANKTRANLIST/"STMTTRN:eq(1)").each do |transaction|
        assert_equal 'DEBIT',                            (transaction/:TRNTYPE).inner_text
        assert_equal '20090803',                         (transaction/:DTPOSTED).inner_text
        assert_equal 'AMZN PMTS',                        (transaction/:NAME).inner_text
        assert_equal '811-209-1987',                     (transaction/:MEMO).inner_text
        assert_equal '-0.03',                            (transaction/:TRNAMT).inner_text
        assert_equal 'f8f014252d03edd2a2d2bdf3b6fac940', (transaction/:FITID).inner_text
      end
    end
    
    def test_should_extract_the_third_credit_transaction
      (@xml/:OFX/:CREDITCARDMSGSRSV1/:CCSTMTTRNRS/:CCSTMTRS/:BANKTRANLIST/"STMTTRN:eq(2)").each do |transaction|
        assert_equal 'CREDIT',                           (transaction/:TRNTYPE).inner_text
        assert_equal '20090803',                         (transaction/:DTPOSTED).inner_text
        assert_equal 'PAYMENT 2 EGG',                    (transaction/:NAME).inner_text
        assert_equal '.',                                (transaction/:MEMO).inner_text
        assert_equal '9.79',                             (transaction/:TRNAMT).inner_text
        assert_equal '0f7f4f3274e4042be4c51d5cd6e151e0', (transaction/:FITID).inner_text
      end
    end
    
    def test_should_extract_the_interest_transaction
      (@xml/:OFX/:CREDITCARDMSGSRSV1/:CCSTMTTRNRS/:CCSTMTRS/:BANKTRANLIST/"STMTTRN:eq(3)").each do |transaction|
        assert_equal 'INT',                               (transaction/:TRNTYPE).inner_text
        assert_equal '20090818',                          (transaction/:DTPOSTED).inner_text
        assert_equal 'CASH INTEREST AT 1.736  PER MONTH', (transaction/:NAME).inner_text
        assert_equal '',                                  (transaction/:MEMO).inner_text
        assert_equal '-10.07',                             (transaction/:TRNAMT).inner_text
        assert_equal 'dda1fbfc6316ab5287bef98b0f251250',  (transaction/:FITID).inner_text
      end
    end
    
    def test_should_extract_the_statement_balance_from_the_html
      assert_equal '-1268.0', (@xml/:OFX/:CREDITCARDMSGSRSV1/:CCSTMTTRNRS/:CCSTMTRS/:LEDGERBAL/:BALAMT).inner_text
    end
    
    def test_should_extract_the_date_of_the_statement_balance_from_the_html
      assert_equal '20090818', (@xml/:OFX/:CREDITCARDMSGSRSV1/:CCSTMTTRNRS/:CCSTMTRS/:LEDGERBAL/:DTASOF).inner_text
    end
  
  end
end