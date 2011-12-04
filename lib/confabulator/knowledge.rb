module Confabulator
  class Knowledge
    def initialize
    end
    
    def find(name)
      knowledge[name] || empty_confabulator
    end
    
    def add(name, sentence = nil)
      if name.is_a?(Hash)
        name.each do |n, s|
          knowledge[n] = Confabulator::Parser.new(s, :knowledge => self)
        end
      else
        knowledge[name] = Confabulator::Parser.new(sentence, :knowledge => self)
      end
    end
    
    def empty_confabulator
      @empty ||= Confabulator::Parser.new("", :knowledge => self)
    end
    
    def knowledge
      @knowledge ||= {}
    end
    
    def clear
      @knowledge = {}
    end
    
    def confabulate(sentence)
      Parser.new(sentence, :knowledge => self).confabulate
    end
  end
end