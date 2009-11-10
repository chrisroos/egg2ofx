require File.dirname(__FILE__) + '/lib/egg'

StatementsFolder = File.dirname(__FILE__) + '/statements/'
OfxOutputFolder = File.dirname(__FILE__) + '/ofx/'

Dir[StatementsFolder + '*.html'].each do |statement_html_file|
  
  html = File.open(statement_html_file) { |f| f.read }
  parser = Egg::Parser.new(html)
  
  filename = File.basename(statement_html_file, '.html')
  File.open(OfxOutputFolder + filename + '.ofx', 'w') do |file|
    file.puts parser.to_ofx
  end
  
end