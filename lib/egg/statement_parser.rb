module Egg
  class StatementParser
    def initialize(html)
      @html = html
    end
    def to_ofx
      doc = Hpricot(@html)

      card_number = (doc/"span#lblCardNumber").inner_html
      statement_date = (doc/'#ctl00_content_eggCardStatements_lstPreviousStatements'/'option[@selected=selected]').first.attributes['value']
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

      ofx_statement = Ofx::Statement.new(statement)
      ofx_statement.to_xml
    end
  end
end