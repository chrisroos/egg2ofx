module Ofx
  require 'builder'
  class Transaction
    def initialize(transaction)
      @transaction = transaction
      @xml = nil
    end
    def to_xml
      @xml ||= (
        buffer = ''
        builder = Builder::XmlMarkup.new(:target => buffer)
        builder.instruct!
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