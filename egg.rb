require File.dirname(__FILE__) + '/lib/egg'
require File.dirname(__FILE__) + '/lib/ofx'

require 'rubygems'
require 'hpricot'

StatementsFolder = File.dirname(__FILE__) + '/statements/'
OfxOutputFolder = File.dirname(__FILE__) + '/ofx/'

Dir[StatementsFolder + '*.html'].each do |statement_html_file|
  
  html = File.open(statement_html_file) { |f| f.read }
  doc = Hpricot(html)
  
  card_number = (doc/"span#lblCardNumber").inner_html
  statement_date = (doc/"span#lblStatementDate").inner_html
  closing_balance = ((doc/"table#tblTransactionsTable"/"tfoot"/"tr").first/"td").inner_html
  account = Egg::Account.new('GBP', card_number)
  statement = Egg::Statement.new(statement_date, closing_balance, account)
  
  (doc/"table#tblTransactionsTable"/"tbody"/"tr").each do |row|
    date = (row/"td.date").inner_text
    description = (row/"td.description").inner_text
    money = (row/"td.money").inner_text
    next if date == '' || description == 'OPENING BALANCE'
    if row.next_sibling && (row.next_sibling/"td.date").inner_text == '' && (row.next_sibling/"td.description").inner_text != ''
      description += ' / ' + (row.next_sibling/"td.description").inner_text
    end
    transaction = Egg::Transaction.new(date, description, money)
    statement.add_transaction(transaction)
  end
  
  ofx_s = Ofx::Statement.new(statement)
  
  filename = File.basename(statement_html_file, '.html')
  File.open(OfxOutputFolder + filename + '.ofx', 'w') do |file|
    # OFX 1.0 format - SGML
    file.puts 'OFXHEADER:100'
    file.puts 'VERSION:103'
    file.puts 'SECURITY:NONE'
    file.puts 'ENCODING:UNICODE'
    file.puts 'OLDFILEUID:NONE'
    file.puts 'NEWFILEUID:NONE'
    # OFX 2.0 format - XML
    # file.puts %q[<?xml version="1.0" encoding="UTF-8"?>]
    # file.puts %q[<?OFX OFXHEADER="200" VERSION="200" SECURITY="NONE" OLDFILEUID="NONE" NEWFILEUID="NONE"?>]
    file.puts(ofx_s.to_xml)
  end
  
end