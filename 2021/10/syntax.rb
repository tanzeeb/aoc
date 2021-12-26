#!/usr/bin/env ruby
# frozen_string_literal: true

scores = {
  ")" => 3,
  "]" => 57,
  "}" => 1197,
  ">" => 25137,
}

endings = {
  "(" => ")",
  "{" => "}",
  "[" => "]",
  "<" => ">",
}

score = 0

ARGF.readlines.each do |line|
  stack = []

  line.chomp.each_char do |char|
    case char
    when "(", "[", "{", "<"
      stack.push endings[char]
    when ")", "]", "}", ">"
      if stack.last != char
        puts "Expected #{stack.last}, but found #{char} instead."

        score += scores[char]

        break
      end

      stack.pop
    end
  end
end

puts score
