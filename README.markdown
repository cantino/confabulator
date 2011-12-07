# Confabulator

A recursive Ruby tempting language for the procedural generation of random sentences.

## Install

    gem install confabulator

## Use

    require 'confabulator'

### Choice blocks

Choice blocks let the parser make a random choice.

    > 5.times { puts Confabulator::Parser.new("{Choice one|Choice two} and stuff").confabulate }
    Choice two and stuff
    Choice one and stuff
    Choice two and stuff
    ...

Recursion is fine (just try to avoid loops):

    > 5.times { puts Confabulator::Parser.new("{Choice {1|2}|Choice 3} and stuff").confabulate }
    Choice 3 and stuff
    Choice 1 and stuff
    Choice 2 and stuff
    ...

You can differentially weight the options: {5:This is 5 times more likely|than this}

### Substitutions

Substitutions let you re-use common templates.

    > knowledge = Confabulator::Knowledge.new
    > knowledge.add "world", "there" # a hash is also acceptable
    > Confabulator::Parser.new("Hello, [world]!", :knowledge => knowledge).confabulate
    => "Hello, there!"

Equivalently:

    > knowledge.confabulate("Hello, [world]!")
    => "Hello, there!"

You can ask a substitution to be capitalized:

    > knowledge.confabulate("Hello, [world:c]!")
    => "Hello, There!"

Or pluralized:

    > knowledge.add "dude" => "friend"
    > knowledge.confabulate("Hello, [dude:p]!")
    => "Hello, friends!"
		
Substitutions can contain other substitutions in choice nodes inside of substitutions, etc., ad infinitum.

### Escaping

You must escape the special characters {, [, `, and | with backslashes:

    > knowledge.add "dude" => "friend"
    > knowledge.confabulate("Hello, \\{friend\\|something\\} \\`\\`stuff\\`\\` \\[dude:p]!")
    => "Hello, {friend|something}  ``stuff`` [dude:p]!!"

### Protected regions

Sometimes you want to insert user generated content without having to escape every {, [, `, and |.  For this you use protected regions.

    > knowledge.add "dude" => "friend"
    > user_content = "protect regions [and stuff] with double backticks (`)!"
    > knowledge.confabulate("Hello, ``#{user_content}``")
    => "Hello, protect regions [and stuff] with double backticks (`)!"

At the moment, sequences of more than one backtick are never allowed inside of a protected region.

## Helping out

Fork, write specs, add a feature, send me a pull request!
