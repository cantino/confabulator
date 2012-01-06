# Confabulator

A recursive syntax for the procedural generation of random sentences in Ruby.

## Why do I care?

Perhaps you want to generate emails, text messages, or webpages that are all readable, but have different wordings.  Perhaps you're writing a game and want to vary character dialog.  Perhaps you're writing a testing language and need a concise way to express linguistic possibilities.  Perhaps you don't need a reason.

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

Choices inside of choices (ad infinitum) are fine:

    > 5.times { puts Confabulator::Parser.new("This is {an example|a {good|great|mediocre} demonstration}").confabulate }
    This is a great demonstration
    This is a mediocre demonstration
    This is an example
    This is a good demonstration
    This is an example
    This is an example
    This is a good demonstration
    ...

You can differentially weight the options: {5:This is 5 times more likely|than this}

### Substitutions

Substitutions let you re-use common templates.

    > knowledge = Confabulator::Knowledge.new
    > knowledge.add "friend", "{friend|world|there}" # a hash is also acceptable
    > Confabulator::Parser.new("Hello, [friend]!", :knowledge => knowledge).confabulate
    => "Hello, there!"
    > Confabulator::Parser.new("Hello, [friend]!", :knowledge => knowledge).confabulate
    => "Hello, world!"
    ...

Equivalently, as a helper on the Knowledge object:

    > knowledge.confabulate("Hello, [friend]!")
    => "Hello, there!"

You can ask a substitution to be capitalized:

    > knowledge.confabulate("Hello, [friend:c]!")
    => "Hello, World!"

Or pluralized:

    > knowledge.add "dude" => "friend"
    > knowledge.confabulate("Hello, [dude:p]!")
    => "Hello, friends!"
		
Substitutions can contain other substitutions inside of choice nodes inside of other substitutions, etc., ad infinitum.  Just try to avoid infinite loops!

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

### Enumerating possible confabulations

You can output an array of all possible confabulations using `all_confabulations`, like so:

    > Confabulator::Parser.new("{Hello|Hi} {world|there}").all_confabulations
    => [
         "Hello world", 
         "Hello there", 
         "Hi world", 
         "Hi there"
       ]

Internally, this calls `tree`, which outputs a simplified confabulation parse tree.

## Next Steps

Here are some things that could be added to this library:

 * Depth limits / recursion detection
 * Learning through back propagation of a reward signal and optimization of the choice nodes to make the rewarded or penalized outcome more or less likely.
 * Whatever you want!

## Helping out

Fork, write specs, add a feature, write documentation, send me a pull request!
