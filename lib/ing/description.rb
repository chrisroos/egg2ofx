module Ing
  class Description
    attr_reader :payee, :note, :territory
    def initialize(description)
      @payee = description
    end
  end
end