require 'rubygems'

require File.dirname(__FILE__) + '/lib/egg'
require File.dirname(__FILE__) + '/lib/ofx'

require 'hpricot'

StatementsFolder = File.dirname(__FILE__) + '/statements/'
OfxOutputFolder = File.dirname(__FILE__) + '/ofx/'

Dir[StatementsFolder + '*.html'].each do |statement_html_file|
  
  html = File.open(statement_html_file) { |f| f.read }
  parser = if statement_html_file =~ /recent-transactions/
    Egg::RecentTransactionsParser.new(html)
  else
    Egg::StatementParser.new(html)
  end
  
  filename = File.basename(statement_html_file, '.html')
  File.open(OfxOutputFolder + filename + '.ofx', 'w') do |file|
    file.puts parser.to_ofx
  end
  
end