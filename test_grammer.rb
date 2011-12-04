require 'rubygems'
require 'treetop'
require 'pp'
Treetop.load 'confabulation'

parser = ConfabulationParser.new
unless parser.parse('[hi][ there ] world sup? \\[hi] world').content.inspect == "[{:sub=>\"hi\"}, {:sub=>\"there\"}, {:text=>\" world sup? \"}, \"\\\\[\", {:text=>\"hi] world\"}]"
  puts "error!"
end

a = '{hi|there {world|people|[variable]}}, how are {you|them}?'
puts a
pp parser.parse(a).content
pp parser.parse(a).compose #({ "variable" => "foo" })
# p parser.parse('[hi][ there ] world sup? {hi} \\[hi] world').content
# p parser.parse('{this|that}').content
# 
# p parser.parse('hello {world|there {dude|person}}}')
# p parser.parse('{{{}}}')
# p parser.parse('{{{hi}}}')
# p parser.parse('silly generativists!')