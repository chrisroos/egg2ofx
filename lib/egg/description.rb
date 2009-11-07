module Egg
  class Description
    attr_reader :payee, :note, :territory
    def initialize(description)
      if m = description.match(/(.{23}) (.{13}) (.{2})?/) # territory (last two chars) is not in recent transactions
        @payee = m[1].strip.squeeze(' ')
        @note = m[2].strip
        @territory = m[3].strip if m[3]
      else
        @payee = description
      end
    end
  end
end