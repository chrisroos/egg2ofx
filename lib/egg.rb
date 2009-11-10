require 'rubygems'
require 'hpricot'
Dir[File.dirname(__FILE__) + '/egg/*.rb'].each { |f| require f }
require File.join(File.dirname(__FILE__), 'ofx')