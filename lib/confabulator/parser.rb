require "rubygems"
require "linguistics"
Linguistics::use( :en )

module Confabulator
  class Parser
    REMOVE_SPACES = /(\S+) {2,}(\S+)/
    attr_accessor :confabulation, :kb
    
    def initialize(str, opts = {})
      self.confabulation = str
      self.kb = opts[:knowledge]
    end
    
    def confabulate
      if parser
        result = parser.confabulate(kb)
        result.gsub!(REMOVE_SPACES, '\1 \2') while result =~ REMOVE_SPACES
        result
      else
        ""
      end
    end
    
    def all_confabulations
      structure = tree
      pp structure
      self.class.expand_tree(structure).tap do |a|
        pp a
      end
    end

    def tree
      parser ? parser.tree(kb) : []
    end
    
    def parser
      if !@parsed # this caches even a nil result
        @cached_parser = ConfabulatorLanguageParser.new.parse(confabulation)
        @parsed = true
      end

      @cached_parser
    end
    
    def self.expand_tree(s, combinations = [], x = nil, *a)
      if !s.is_a?(String) && combinations == []
        expand_tree("", combinations, *s)
      else
        case x
          when Hash then x[:choices].each{|x| expand_tree(s, combinations, x, *a)}
          when Array then expand_tree(s, combinations, *x, *a)
          when String then expand_tree(s+x, combinations, *a)
          when nil then combinations << s
        end
        combinations
      end
    end

    def self.remove_singleton_arrays(arr)
      if arr.is_a?(Array)
        if arr.length == 1
          remove_singleton_arrays(arr.first)
        else
          arr.map { |a| remove_singleton_arrays(a) }
        end
      else
        arr
      end
    end
  end
end
