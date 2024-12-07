#!/usr/bin/env ruby
# frozen_string_literal: true

left = []
right = Hash.new(0)
sim = []

ARGF.readlines(chomp: true).each do |line|
  l, r = line.split(/\W+/).map(&:to_i)

  left << l
  right[r] += 1
end

left.each do |l|
  sim << l * right[l]
end

puts sim.sum
