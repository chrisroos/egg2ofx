require 'rubygems'
require 'hpricot'

statement_html_file = File.dirname(__FILE__) + '/INGDirect.html'
html = File.open(statement_html_file) { |f| f.read }
doc = Hpricot(html)

# Read account details (transaction_period, customer_name, account_number, account_name)
account_details = {}
(doc/"tr.grey_table_top td b").each do |e|
  name = e.inner_text.gsub(/&nbsp;/, ' ').downcase.gsub(/ /, '_').to_sym
  value = e.parent.siblings_at(2).inner_text.gsub(/&nbsp;/, ' ').chomp.strip
  account_details[name] = value
end
p account_details

transactions = []
(doc/"table[@summary='Transactional Data']").each do |table|
  (table/"tr").each do |row|
    transaction = []
    (row/"td.tpTableRow1, td.tpTableRow2").each do |cell|
      transaction << cell.inner_text.gsub(/&nbsp;/, ' ')
    end
    transactions << transaction unless transaction.empty?
  end
end

puts transactions.collect { |tran| tran.join("\t") }

#**********************************************************************************

require File.dirname(__FILE__) + '/../lib/ing'
require File.dirname(__FILE__) + '/ofx'

account_number = account_details[:account_number]
statement_date = account_details[:transaction_period]
closing_balance = transactions.first.last

account = Ing::Account.new('GBP', account_number, 'SORT_CODE')
statement = Ing::Statement.new(statement_date, closing_balance, account)
transactions.each do |t|
  date = t.first
  description = t[1]
  money = t[2]
  transaction = Ing::Transaction.new(date, description, money)
  statement.add_transaction(transaction)
end

ofx_s = Ofx::Statement.new(statement)

filename = File.dirname(__FILE__) + '/../ing.ofx'
File.open(filename, 'w') do |file|
  file.puts 'OFXHEADER:200'
  file.puts 'VERSION:203'
  file.puts 'SECURITY:NONE'
  file.puts 'OLDFILEUID:NONE'
  file.puts 'NEWFILEUID:NONE'
  file.puts(ofx_s.to_xml)
end