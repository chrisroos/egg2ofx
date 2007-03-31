require File.dirname(__FILE__) + '/date'

module Egg
  class Account
    def initialize(currency, number)
      @currency, @number = currency, number
    end
    attr_reader :currency, :number
  end
  class Money
    def initialize(money)
      money = money.sub(/£/, '').gsub(/,/, '')
      md = money.match(/(\d+\.\d+) ([A-Z]+)/)
      @money = md ? Float(md[1]) : 0
      @money = -@money if md && md[2] == 'DR'
    end
    def to_f
      @money
    end
  end
  class Statement
    def initialize(statement_date, closing_balance, account)
      from_date, to_date = statement_date.split(' to ')
      @from_date = Date.build(from_date)
      @to_date = Date.build(to_date)
      @closing_balance = Money.new(closing_balance).to_f
      @account = account
      @transactions = []
    end
    attr_reader :from_date, :to_date, :closing_balance, :transactions
    def add_transaction(transaction)
      transaction.date = from_date unless transaction.date
      @transactions << transaction
    end
    def account_currency
      @account.currency
    end
    def account_number
      @account.number
    end
  end
  require 'digest/md5'
  class Transaction
    def initialize(date, description, money)
      @date = Date.build(date)
      @description = description.squeeze(' ')
      @amount = Money.new(money).to_f
      @ofx_id = nil
    end
    attr_reader :date, :description, :amount
    def ofx_id
      @ofx_id ||= Digest::MD5.hexdigest(to_s)
    end
    def to_s
      [date, description, amount].join(', ')
    end
    def type
      if description =~ /INTEREST/
        'INT'
      else
        (amount < 0) ? 'DEBIT' : 'CREDIT'
      end
    end
  end
end

require 'rubygems'
require 'hpricot'

Statement = '2007-03-18'

html = File.open('statements/' + Statement + '.html') { |f| f.read }
doc = Hpricot(html)

# card_type = (doc/"span#lblCardTypeName").inner_html
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