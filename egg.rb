module Egg
  require 'digest/md5'
  require 'date'
  class Transaction
    def initialize
      # MAYBE INITIALIZE WITH A STATEMENT SO THAT WE CAN SET DATES FOR UNKNOWN ITEMS TO THE EARLIEST DATE OF THE STATEMENT
      @ofx_id, clean_description = nil, nil
    end
    def money=(money)
      money = money.sub(/£/, '').gsub(/,/, '')
      md = money.match(/(\d+\.\d+) ([A-Z]+)/)
      @amount = md ? Float(md[1]) : 0
      @amount = -@amount if md && md[2] == 'DR'
    end
    attr_reader :amount
    def date=(date)
      @date = Date.parse(date) rescue ''  
    end
    attr_reader :date
    def description=(description)
      @description = description.squeeze(' ')
    end
    attr_reader :description
    def ofx_id
      @ofx_id ||= Digest::MD5.hexdigest(to_s)
    end
    def to_s
      [date, description, amount].join(', ')
    end
  end
end

transactions = []

# html = File.open('statements.aspx.html') { |f| f.read }
# transaction_table = html[/<table id="tblTransactionsTable".*?<\/table>/m]
# body = transaction_table[/<tbody.*?<\/tbody>/m]
# body.scan(/<tr.*?>.*?<\/tr>/m).each do |row|
#   transaction = Egg::Transaction.new
#   row.scan(/<td(.*)?>(.*?)<\/td>/).each do |(row_attrs, data)|
#     css_class = row_attrs[/class="(.*?)"/, 1]
#     transaction.__send__("#{css_class}=", data)
#   end
#   transactions << transaction
# end

require 'rubygems'
require 'hpricot'

html = File.open('statements.aspx.html') { |f| f.read }
doc = Hpricot(html)

card_type = (doc/"span#lblCardTypeName").inner_html
card_number = (doc/"span#lblCardNumber").inner_html
statement_date = (doc/"span#lblStatementDate").inner_html

(doc/"table#tblTransactionsTable"/"tbody"/"tr").each do |row|
  date = (row/"td.date").inner_text
  description = (row/"td.description").inner_text
  money = (row/"td.money").inner_text
  transaction = Egg::Transaction.new
  transaction.date = date
  transaction.description = description
  transaction.money = money
  transactions << transaction
end

# SORT OUT OPENING BALANCE

require 'ofx'
transactions.each do |transaction|
  ofx_t = Ofx::Transaction.new(transaction)
  puts ofx_t.to_xml
end