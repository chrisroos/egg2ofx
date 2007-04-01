module Egg
  class Description
    attr_reader :payee, :note, :territory
    def initialize(description)
      if m = description.match(/(.{23}) (.{13}) (.{2})/)
        @payee = m[1].strip.squeeze(' ')
        @note = m[2].strip
        @territory = m[3].strip
      else
        @payee = description
      end
    end
  end
end