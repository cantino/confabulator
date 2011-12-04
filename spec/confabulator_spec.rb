# encoding: UTF-8
require 'spec_helper'

describe Confabulator do
  describe "choice blocks" do
    it "should work" do
      100.times.map {
        Confabulator::Parser.new("{Choice one|Choice two} and stuff").confabulate
      }.uniq.sort.should == [
        "Choice one and stuff",
        "Choice two and stuff"
      ]
    end

    it "should be recursive" do
      100.times.map {
        Confabulator::Parser.new("{Choice {1|2}|Choice 3} and stuff").confabulate
      }.uniq.sort.should == [
        "Choice 1 and stuff",
        "Choice 2 and stuff",
        "Choice 3 and stuff"
      ]
    end
  end
  
  describe "substitutions" do
    it "should use the knowledge base" do
      knowledge = Confabulator::Knowledge.new
      knowledge.add "world", "there"
      Confabulator::Parser.new("Hello, [world]!", :knowledge => knowledge).confabulate.should == "Hello, there!"
    end
    
    it "should return an empty string if it cannot be found" do
      Confabulator::Parser.new("Hello, [world]!").confabulate.should == "Hello, !"
    end

    it "should work recursively" do
      k = Confabulator::Knowledge.new
      k.add "expand" => "is [recursive]", 
            "recursive" => "pretty cool"
      k.confabulate("Hello, this [expand]!").should == "Hello, this is pretty cool!"
    end
    
    it "should work with choices too" do
      k = Confabulator::Knowledge.new
      k.add "expand" => "is {[recursive]|not recursive}", "recursive" => "pretty cool"
      100.times.map {
        Confabulator::Parser.new("Hello, this [expand]!", :knowledge => k).confabulate
      }.uniq.sort.should == [
        "Hello, this is not recursive!",
        "Hello, this is pretty cool!"
      ]
    end
  end
end
