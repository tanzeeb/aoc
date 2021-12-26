#!/usr/bin/env ruby
# frozen_string_literal: true

points = {
  ")" => 1,
  "]" => 2,
  "}" => 3,
  ">" => 4,
}

endings = {
  "(" => ")",
  "{" => "}",
  "[" => "]",
  "<" => ">",
}

scores = []

ARGF.readlines.each do |line|
  stack = []

  line.chomp.each_char do |char|
    case char
    when "(", "[", "{", "<"
      stack.push endings[char]
    when ")", "]", "}", ">"
      if stack.last != char
        raise "Expected #{stack.last}, but found #{char} instead."

        break
      end

      stack.pop
    end
  end rescue next

  scores << stack.reverse.inject(0) { |t,c| t*5 + points[c] } 
end

puts scores.sort.slice(scores.size/2)
