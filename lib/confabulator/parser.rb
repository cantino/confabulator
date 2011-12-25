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
      self.class.expand_tree(tree)
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
          when Hash
            if x[:choices]
              x[:choices].each {|c| expand_tree(s, combinations, c, *a)}
            elsif x[:pluralize]
              tree_below_here = expand_tree("", [], x[:pluralize]).map { |r| r.en.plural }
              expand_tree(s, combinations, { :choices => tree_below_here })
            elsif x[:capitalize]
              tree_below_here = expand_tree("", [], x[:capitalize])
              tree_below_here.each { |r| r[0] = r[0].upcase if r[0] }
              expand_tree(s, combinations, { :choices => tree_below_here })
            else
              raise "Hash found without :choices, :pluralize, or :capitalize in it: #{x.inspect}"
            end
          when Array
            expand_tree(s, combinations, *x, *a)
          when String
            expand_tree(s+x, combinations, *a)
          when nil
            combinations << s
          else
            raise "Non String, Array, Hash, or nil value in expand_tree: #{x.inspect}"
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
