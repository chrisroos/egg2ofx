require 'rubygems'
require 'hpricot'

class Parser
  def initialize(html)
    @doc = Hpricot(html)
  end
  def parse_account_details(&blk)
    (@doc/"tr.grey_table_top td b").each do |e|
      name = e.inner_text.gsub(/&nbsp;/, ' ').downcase.gsub(/ /, '_').to_sym
      value = e.parent.siblings_at(2).inner_text.gsub(/&nbsp;/, ' ').chomp.strip
      yield [name, value]
    end
  end
  def parse_transactions(&blk)
    headers = [:date, :description, :amount, :balance]
    (@doc/"table[@summary='Transactional Data']").each do |table|
      (table/"tr").each do |row|
        transaction = []
        (row/"td.tpTableRow1, td.tpTableRow2").each do |cell|
          value = cell.inner_text.gsub(/&nbsp;/, ' ').strip
          transaction << value
        end
        yield Hash[*headers.zip(transaction).flatten] unless transaction.empty?
      end
    end  
  end
end

class Normalizer
  # HOW SHOULD PARSER AND NORMALIZER WORK TOGETHER?????
end

statement_html_file = File.dirname(__FILE__) + '/INGDirect.html'
html = File.open(statement_html_file) { |f| f.read }
parser = Parser.new(html)

parser.parse_account_details { |k, v| p [k, v] }
parser.parse_transactions { |t| p t }