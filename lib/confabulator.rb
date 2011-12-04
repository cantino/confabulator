require "confabulator/version"
require 'treetop'
require 'pp'

module Confabulator
  class Parser
    attr_accessor :confabulation
    
    def self.initialize(str)
      load_parser
      self.confabulation = str
    end
    
    def confabulate
      parser.parse(confabulation).compose
    end
    
    def parser
      @cached_parser ||= ConfabulatorParser.new
    end
    
    def self.load_parser
      if !defined?(ConfabulatorParser)
        Treetop.load File.join(File.expand_path(File.dirname(__FILE__), 'confabulator', 'grammer'))
      end
    end
  end
end
