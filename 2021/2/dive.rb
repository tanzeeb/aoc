#!/usr/bin/env ruby
# frozen_string_literal: true

depth = 0
horizontal = 0

ARGF.readlines.each do |line|
  command, distance = line.split

  case command
  when 'forward'
    horizontal += distance.to_i
  when 'down'
    depth += distance.to_i
  when 'up'
    depth -= distance.to_i
  end
end

puts depth * horizontal
