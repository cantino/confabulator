module Confabulator
  class Parser
    attr_accessor :confabulation
    
    def initialize(str)
      self.confabulation = str
    end
    
    def confabulate
      if parser
        parser.compose
      else
        ""
      end
    end
    
    def parser
      if !@parsed # this caches even a nil result
        @cached_parser = ConfabulatorLanguageParser.new.parse(confabulation)
        @parsed = true
      end

      @cached_parser
    end
  end
end
