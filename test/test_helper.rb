require 'test/unit'
require 'rubygems'
require 'mocha'

require File.join(File.dirname(__FILE__), '..', 'lib', 'egg')

FIXTURES = File.join(File.dirname(__FILE__), 'fixtures') unless defined?(FIXTURES)