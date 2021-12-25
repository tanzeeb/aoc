#!/usr/bin/env ruby
# frozen_string_literal: true

count = 0

ARGF.readlines.each do |line|
  digits, display = line.chomp.split(" | ").map { |part| part.split.map {|signal| signal.split('').sort.join('') } }

  display.each do |signal|
    count += 1 if [2,3,4,7].include? signal.size
  end
end

puts count
