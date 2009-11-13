require 'builder'

module Ofx
  class Statement
    def initialize(statement)
      @statement = statement
      @xml = nil
    end
    def to_xml
      @xml ||= (
        buffer = ''
        builder = Builder::XmlMarkup.new(:target => buffer, :indent => 2)
        builder.instruct!
        builder << '<?OFX OFXHEADER="200" VERSION="200" SECURITY="NONE" OLDFILEUID="NONE" NEWFILEUID="NONE"?>'
        builder.OFX do
          builder.CREDITCARDMSGSRSV1 do
            builder.CCSTMTTRNRS do
              builder.CCSTMTRS do
                builder.CURDEF @statement.account_currency
                builder.CCACCTFROM do
                  builder.ACCTID @statement.account_number
                end
                builder.BANKTRANLIST do
                  builder.DTSTART @statement.from_date
                  builder.DTEND @statement.to_date
                  @statement.transactions.each do |transaction|
                    builder.STMTTRN do
                      builder.TRNTYPE transaction.type
                      builder.DTPOSTED transaction.date
                      builder.NAME transaction.payee
                      builder.MEMO transaction.note
                      builder.TRNAMT transaction.amount
                      builder.FITID transaction.ofx_id
                    end
                  end
                end
                builder.LEDGERBAL do
                  builder.BALAMT @statement.closing_balance
                  builder.DTASOF @statement.to_date
                end
              end
            end
          end
        end
        buffer
      )
    end
  end
end