#!/usr/bin/env ruby
# frozen_string_literal: true

depth = 0
horizontal = 0
aim = 0

ARGF.readlines.each do |line|
  command, units = line.split
  x = units.to_i

  case command
  when 'forward'
    horizontal += x
    depth += aim * x
  when 'down'
    aim += x
  when 'up'
    aim -= x
  end
end

puts depth * horizontal
