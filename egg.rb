require File.dirname(__FILE__) + '/date'
require File.dirname(__FILE__) + '/account'
require File.dirname(__FILE__) + '/money'
require File.dirname(__FILE__) + '/statement'
require File.dirname(__FILE__) + '/transaction'

require 'rubygems'
require 'hpricot'

Statement = '2007-03-18'

html = File.open('statements/' + Statement + '.html') { |f| f.read }
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

require 'ofx'
ofx_s = Ofx::Statement.new(statement)

File.open(File.dirname(__FILE__) + '/ofx/' + Statement + '.ofx', 'w') do |file|
  file.puts 'OFXHEADER:200'
  file.puts 'VERSION:203'
  file.puts 'SECURITY:NONE'
  file.puts 'OLDFILEUID:NONE'
  file.puts 'NEWFILEUID:NONE'
  file.puts(ofx_s.to_xml)
end