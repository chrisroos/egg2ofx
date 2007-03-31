module Ofx
  require 'builder'
  class Statement
    def initialize(statement)
      @statement = statement
      @xml = nil
    end
    def to_xml
      @xml ||= (
        buffer = ''
        builder = Builder::XmlMarkup.new(:target => buffer)
        builder.instruct!
        builder.BANKTRANLIST do
          builder.DTSTART @statement.from_date
          builder.DTEND @statement.to_date
          @statement.transactions.each do |transaction|
            builder << Transaction.new(transaction).to_xml
          end
        end
        buffer
      )
    end
  end
  class Transaction
    def initialize(transaction)
      @transaction = transaction
      @xml = nil
    end
    def to_xml
      @xml ||= (
        buffer = ''
        builder = Builder::XmlMarkup.new(:target => buffer)
        builder.STMTTRN do
          builder.TRNTYPE 'tran_type'
          builder.DTPOSTED @transaction.date
          builder.NAME @transaction.description
          builder.TRNAMT @transaction.amount
          builder.FITID @transaction.ofx_id
        end
        buffer
      )
    end
  end
end