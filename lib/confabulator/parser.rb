require "rubygems"
require "linguistics"
Linguistics::use( :en )

module Confabulator
  class Parser
    attr_accessor :confabulation, :kb
    
    def initialize(str, opts = {})
      self.confabulation = str
      self.kb = opts[:knowledge]
    end
    
    def confabulate
      if parser
        parser.compose(kb).squeeze(" ")
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
