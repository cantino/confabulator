# Autogenerated from a Treetop grammar. Edits may be lost.


module Confabulator
	module ConfabulatorLanguage
   include Treetop::Runtime

   def root
     @root ||= :sentence
   end

   module Sentence0
				def content
					{ :sentence => elements.map { |e| e.content } }
				end
			
				def compose
					elements.map(&:compose).join
				end
   end

   def _nt_sentence
     start_index = index
     if node_cache[:sentence].has_key?(index)
       cached = node_cache[:sentence][index]
       if cached
         cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
         @index = cached.interval.end
       end
       return cached
     end

     s0, i0 = [], index
     loop do
       i1 = index
       r2 = _nt_substitution
       if r2
         r1 = r2
       else
         r3 = _nt_choice
         if r3
           r1 = r3
         else
           r4 = _nt_escaped_char
           if r4
             r1 = r4
           else
             r5 = _nt_words
             if r5
               r1 = r5
             else
               @index = i1
               r1 = nil
             end
           end
         end
       end
       if r1
         s0 << r1
       else
         break
       end
     end
     if s0.empty?
       @index = i0
       r0 = nil
     else
       r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
       r0.extend(Sentence0)
     end

     node_cache[:sentence][start_index] = r0

     r0
   end

   module Choice0
     def sentence
       elements[1]
     end
   end

   module Choice1
     def first_sentence
       elements[1]
     end

     def rest_sentences
       elements[2]
     end

   end

   module Choice2
				def content
					{ :list => ([first_sentence.content] + rest_sentences.elements.map { |s| s.sentence.content }).flatten }
				end

				def compose
					elems = [first_sentence] + rest_sentences.elements.map { |s| s.sentence }
					elems[elems.length * rand].compose
				end
   end

   def _nt_choice
     start_index = index
     if node_cache[:choice].has_key?(index)
       cached = node_cache[:choice][index]
       if cached
         cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
         @index = cached.interval.end
       end
       return cached
     end

     i0, s0 = index, []
     if has_terminal?('{', false, index)
       r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
       @index += 1
     else
       terminal_parse_failure('{')
       r1 = nil
     end
     s0 << r1
     if r1
       r2 = _nt_sentence
       s0 << r2
       if r2
         s3, i3 = [], index
         loop do
           i4, s4 = index, []
           if has_terminal?('|', false, index)
             r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
             @index += 1
           else
             terminal_parse_failure('|')
             r5 = nil
           end
           s4 << r5
           if r5
             r6 = _nt_sentence
             s4 << r6
           end
           if s4.last
             r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
             r4.extend(Choice0)
           else
             @index = i4
             r4 = nil
           end
           if r4
             s3 << r4
           else
             break
           end
         end
         r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
         s0 << r3
         if r3
           if has_terminal?('}', false, index)
             r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
             @index += 1
           else
             terminal_parse_failure('}')
             r7 = nil
           end
           s0 << r7
         end
       end
     end
     if s0.last
       r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
       r0.extend(Choice1)
       r0.extend(Choice2)
     else
       @index = i0
       r0 = nil
     end

     node_cache[:choice][start_index] = r0

     r0
   end

   module Substitution0
   end

   module Substitution1
     def w1
       elements[2]
     end

     def name
       elements[3]
     end

     def w2
       elements[4]
     end

   end

   module Substitution2
				def content
					{ :sub => name.text_value }
				end
			
				def compose
					Confabulator::Knowledge.find(name.text_value).confabulate
				end
   end

   def _nt_substitution
     start_index = index
     if node_cache[:substitution].has_key?(index)
       cached = node_cache[:substitution][index]
       if cached
         cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
         @index = cached.interval.end
       end
       return cached
     end

     i0, s0 = index, []
     i1 = index
     if has_terminal?('\\\\', false, index)
       r2 = instantiate_node(SyntaxNode,input, index...(index + 2))
       @index += 2
     else
       terminal_parse_failure('\\\\')
       r2 = nil
     end
     if r2
       r1 = nil
     else
       @index = i1
       r1 = instantiate_node(SyntaxNode,input, index...index)
     end
     s0 << r1
     if r1
       if has_terminal?('[', false, index)
         r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
         @index += 1
       else
         terminal_parse_failure('[')
         r3 = nil
       end
       s0 << r3
       if r3
         r4 = _nt_w
         s0 << r4
         if r4
           i5, s5 = index, []
           if has_terminal?('\G[a-zA-Z]', true, index)
             r6 = true
             @index += 1
           else
             r6 = nil
           end
           s5 << r6
           if r6
             s7, i7 = [], index
             loop do
               if has_terminal?('\G[a-zA-Z_0-9-]', true, index)
                 r8 = true
                 @index += 1
               else
                 r8 = nil
               end
               if r8
                 s7 << r8
               else
                 break
               end
             end
             r7 = instantiate_node(SyntaxNode,input, i7...index, s7)
             s5 << r7
           end
           if s5.last
             r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
             r5.extend(Substitution0)
           else
             @index = i5
             r5 = nil
           end
           s0 << r5
           if r5
             r9 = _nt_w
             s0 << r9
             if r9
               if has_terminal?(']', false, index)
                 r10 = instantiate_node(SyntaxNode,input, index...(index + 1))
                 @index += 1
               else
                 terminal_parse_failure(']')
                 r10 = nil
               end
               s0 << r10
             end
           end
         end
       end
     end
     if s0.last
       r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
       r0.extend(Substitution1)
       r0.extend(Substitution2)
     else
       @index = i0
       r0 = nil
     end

     node_cache[:substitution][start_index] = r0

     r0
   end

   module W0
				def content
					text_value
				end

				def compose
					text_value
				end
   end

   def _nt_w
     start_index = index
     if node_cache[:w].has_key?(index)
       cached = node_cache[:w][index]
       if cached
         cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
         @index = cached.interval.end
       end
       return cached
     end

     s0, i0 = [], index
     loop do
       if has_terminal?('\G[ \\t]', true, index)
         r1 = true
         @index += 1
       else
         r1 = nil
       end
       if r1
         s0 << r1
       else
         break
       end
     end
     r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
     r0.extend(W0)

     node_cache[:w][start_index] = r0

     r0
   end

   module EscapedChar0
   end

   module EscapedChar1
				def content
					text_value
				end

				def compose
					text_value
				end
   end

   def _nt_escaped_char
     start_index = index
     if node_cache[:escaped_char].has_key?(index)
       cached = node_cache[:escaped_char][index]
       if cached
         cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
         @index = cached.interval.end
       end
       return cached
     end

     i0, s0 = index, []
     if has_terminal?('\\', false, index)
       r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
       @index += 1
     else
       terminal_parse_failure('\\')
       r1 = nil
     end
     s0 << r1
     if r1
       if index < input_length
         r2 = instantiate_node(SyntaxNode,input, index...(index + 1))
         @index += 1
       else
         terminal_parse_failure("any character")
         r2 = nil
       end
       s0 << r2
     end
     if s0.last
       r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
       r0.extend(EscapedChar0)
       r0.extend(EscapedChar1)
     else
       @index = i0
       r0 = nil
     end

     node_cache[:escaped_char][start_index] = r0

     r0
   end

   module Words0
	   		def content
	     		text_value
	   		end

				def compose
					text_value
				end
   end

   def _nt_words
     start_index = index
     if node_cache[:words].has_key?(index)
       cached = node_cache[:words][index]
       if cached
         cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
         @index = cached.interval.end
       end
       return cached
     end

     s0, i0 = [], index
     loop do
       if has_terminal?('\G[^\\[{}\\|\\\\]', true, index)
         r1 = true
         @index += 1
       else
         r1 = nil
       end
       if r1
         s0 << r1
       else
         break
       end
     end
     if s0.empty?
       @index = i0
       r0 = nil
     else
       r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
       r0.extend(Words0)
     end

     node_cache[:words][start_index] = r0

     r0
   end

   module Char0
   end

   module Char1
				def content
					text_value
				end
	
				def compose
					text_value
				end
   end

   def _nt_char
     start_index = index
     if node_cache[:char].has_key?(index)
       cached = node_cache[:char][index]
       if cached
         cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
         @index = cached.interval.end
       end
       return cached
     end

     i0, s0 = index, []
     i1 = index
     if has_terminal?('\\\\', false, index)
       r2 = instantiate_node(SyntaxNode,input, index...(index + 2))
       @index += 2
     else
       terminal_parse_failure('\\\\')
       r2 = nil
     end
     if r2
       r1 = nil
     else
       @index = i1
       r1 = instantiate_node(SyntaxNode,input, index...index)
     end
     s0 << r1
     if r1
       if index < input_length
         r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
         @index += 1
       else
         terminal_parse_failure("any character")
         r3 = nil
       end
       s0 << r3
     end
     if s0.last
       r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
       r0.extend(Char0)
       r0.extend(Char1)
     else
       @index = i0
       r0 = nil
     end

     node_cache[:char][start_index] = r0

     r0
   end

 end

 class ConfabulatorLanguageParser < Treetop::Runtime::CompiledParser
   include ConfabulatorLanguage
 end

end