#!/usr/bin/env ruby
# frozen_string_literal: true

sum = 0

ARGF.readlines.each do |line|
  digits, display = line.chomp.split(" | ").map { |part| part.split.map {|signal| signal.split('').sort } }

  guesses = {}

  guesses[1] = digits.find {|d| d.size == 2}
  guesses[4] = digits.find {|d| d.size == 4}
  guesses[7] = digits.find {|d| d.size == 3}
  guesses[8] = digits.find {|d| d.size == 7}

  guesses[3] = digits.find {|d| d.size == 5 && (guesses[1] - d).empty? }

  guesses[9] = digits.find {|d| d.size == 6 && (guesses[3] - d).empty? }
  guesses[0] = digits.find {|d| d.size == 6 && d != guesses[9] && (guesses[1] - d).empty? }
  guesses[6] = digits.find {|d| d.size == 6 && d != guesses[9] && d != guesses[0] }

  guesses[5] = digits.find {|d| d.size == 5 && d != guesses[3] && (d - guesses[6]).empty? }
  guesses[2] = digits.find {|d| d.size == 5 && d != guesses[3] && d != guesses[5] }

  lookup = guesses.invert
  entry = "%d%d%d%d" % display.map {|d| lookup[d]}

  sum += entry.to_i
end

puts sum
