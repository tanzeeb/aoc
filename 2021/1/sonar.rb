#!/usr/bin/env ruby

inc = 0
last = nil

ARGF.readlines.each do |line|
  current = line.to_i

  inc += 1 if last && current > last

  last = current
end

puts inc
