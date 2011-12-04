module Confabulator
  class Knowledge
    def self.find(name)
      knowledge[name] || empty_confabulator
    end
    
    def self.add(name, sentence = nil)
      if name.is_a?(Hash)
        name.each do |n, s|
          knowledge[n] = Confabulator::Parser.new(s)
        end
      else
        knowledge[name] = Confabulator::Parser.new(sentence)
      end
    end
    
    def self.empty_confabulator
      @empty ||= Confabulator::Parser.new("")
    end
    
    def self.knowledge
      @knowledge ||= {}
    end
    
    def self.clear
      @knowledge = {}
    end
  end
end