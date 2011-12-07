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
    
    it "should allow differential weighting" do
      one = two = 0
      500.times do
        case Confabulator::Parser.new("{5:Choice 1|Choice 2} and stuff").confabulate
          when "Choice 1 and stuff"
            one += 1
          when "Choice 2 and stuff"
            two += 1
        end
      end
      one.should > two * 3
      one.should < two * 7
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
    
    it "should be able to capitalize" do
      k = Confabulator::Knowledge.new
      k.add "blah" => "world foo"
      k.confabulate("Hello. [blah:c]!").should == "Hello. World foo!"
    end

    it "should be able to pluralize" do
      k = Confabulator::Knowledge.new
      k.add "blah" => "ancient dog"
      k.confabulate("Many [blah:p]!").should == "Many ancient dogs!"
    end
  end
  
  describe "general behavior" do
    before do
      @k = Confabulator::Knowledge.new
      @k.add "expand" => "  is {[recursive]|  not recursive}", "recursive" => "pretty   cool "
    end

    it "should remove repeated spaces between words" do
      @k.confabulate("Hello, this  [expand]!").should_not =~ /  /
    end
    
    it "should not remove leading spaces" do
      @k.confabulate("  Hello, this  [expand]!").should =~ /^  Hello/
      @k.confabulate("Foo    bar\n\n   baz").should == "Foo bar\n\n   baz"
      @k.confabulate("List:\n  * foo\n  * bar baz     bing  blah").should == "List:\n  * foo\n  * bar baz bing blah"
    end
  end
  
  describe "protected regions" do
    it "should not parse content inside of the region" do
      k = Confabulator::Knowledge.new
      k.add "expand" => "is ``{[recursive]|not recursive} single ticks (`) are ok``"
      Confabulator::Parser.new("Hello, this [expand]!", :knowledge => k).confabulate.should == "Hello, this is {[recursive]|not recursive} single ticks (`) are ok!"
    end
  end
  
  describe "escaped characters" do
    it "should show up as unescaped" do
      Confabulator::Parser.new("Hi \\[foo]\\{bar\\|foo\\}\\`baz\\` and stuff").confabulate.should == "Hi [foo]{bar|foo}`baz` and stuff"
    end
  end
end
