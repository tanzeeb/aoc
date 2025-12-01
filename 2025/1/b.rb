#!/usr/bin/env ruby
# frozen_string_literal: true

current = 50
count = 0

ARGF.readlines(chomp: true).each do |line|
  print "#{count} - #{current} - #{line}"
  case line
  when /^L(\d+)$/
    rotation = Regexp.last_match(1).to_i
    count += rotation / 100

    print " * L#{rotation % 100} - #{rotation / 100} + #{(current - rotation % 100) < 0 ? 1 : 0}" if rotation >= 100

    rotation %= 100

    current = (current - rotation)
    count += 1 if current < 0

    current %= 100
  when /^R(\d+)$/
    rotation = Regexp.last_match(1).to_i
    count += rotation / 100

    print " * R#{rotation % 100} - #{rotation / 100} + #{(current + rotation % 100) >= 100 ? 1 : 0}" if rotation >= 100

    rotation %= 100

    current = (current + rotation)
    count += 1 if current >= 100

    current %= 100
  end
  print "\n"
end

puts count
