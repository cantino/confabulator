require 'rubygems'
$: << File.expand_path(File.join(File.dirname(__FILE__), "lib"))
require 'confabulator'

kb = Confabulator::Knowledge.new
kb.add "ok" => "{ok|sure|sure thing|no problem|gotcha}",
       "time" => "{current time|time}"
puts kb.confabulate("[ok], the [time] is #{Time.now}")
