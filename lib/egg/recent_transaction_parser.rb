module Egg
  
  class RecentTransactionsParser

    def initialize(html)
      @html = html
    end

    def to_ofx
      doc = Hpricot(@html)

      card_number = (doc/"span#lblCardNumber").inner_html
      first_transaction_date = (doc/'#tblTransactionsTable'/'tbody'/'tr'/'td.date').first.inner_text
      last_transaction_date = (doc/'#tblTransactionsTable'/'tbody'/'tr'/'td.date').last.inner_text
      statement_date = "#{first_transaction_date} to #{last_transaction_date}"
      closing_balance = ((doc/"table#tblTransactionsTable"/"tfoot"/"tr").first/"td").inner_html

      account = Egg::Account.new('GBP', card_number)

      statement = Egg::Statement.new(statement_date, closing_balance, account)

      (doc/"table#tblTransactionsTable"/"tbody"/"tr").each do |row|
        date = (row/"td.date").inner_text
        description = (row/"td.description").inner_text
        money = (row/"td.money").inner_text.sub(/^\?/, '')
        # Amounts in recent transactions are represented differently (-1 and 1 vs 1 CR and 1 DR)
        if money =~ /^\-/
          money = money << ' CR'
        else
          money = money << ' DR'
        end
        transaction = Egg::Transaction.new(date, description, money)
        statement.add_transaction(transaction)
      end

      ofx_s = Ofx::Statement.new(statement)

<<-EndOfx
<?xml version="1.0" encoding="UTF-8"?>
<?OFX OFXHEADER="200" VERSION="200" SECURITY="NONE" OLDFILEUID="NONE" NEWFILEUID="NONE"?>
#{ofx_s.to_xml}
EndOfx
    end

  end
  
end