# Confabulator

A recursive Ruby tempting language for the procedural generation of random sentences.

## Choice blocks

		> 5.times { puts Confabulator::Parser.new("{Choice one|Choice two} and stuff").confabulate }
		Choice one and stuff
		Choice one and stuff
		...
		# Recursion is fine!
		> 5.times { puts Confabulator::Parser.new("{Choice {1|2}|Choice 3} and stuff").confabulate }
		Choice 1 and stuff
		Choice 2 and stuff
		Choice 3 and stuff
		...
		# You can differentially weight the options: {5:This is 5 times more likely|than this}

## Substitutions

		> knowledge = Confabulator::Knowledge.new
		> knowledge.add "world", "there"
		> Confabulator::Parser.new("Hello, [world]!", :knowledge => knowledge)
		=> "Hello, there!"
		# Equivalently:
		> knowledge.confabulate("Hello, [world]!")
		=> "Hello, there!"
		# You can ask a substitution to be capitalized:
		> knowledge.confabulate("Hello, [world:c]!")
		=> "Hello, There!"
		# Or pluralized:
		> knowledge.add "dude", "friend"
		> knowledge.confabulate("Hello, [dude:p]!")
		=> "Hello, friends!"
		
		# Substitutions can contain other substitutions in choice nodes inside of substitutions, etc., ad infinitum.
