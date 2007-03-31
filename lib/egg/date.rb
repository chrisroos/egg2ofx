require 'date'

module Egg
  class Date
    def self.build(date)
      return nil if date == ''
      ::Date.parse(date).strftime('%Y%m%d')
    end
  end
end