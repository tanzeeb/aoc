#!/usr/bin/env ruby
# frozen_string_literal: true

sum = 0

ARGF.readlines(chomp: true).each do |line|
  batteries = line.split(//).map(&:to_i)

  max = 0

  batteries.each_with_index do |a, i|
    batteries[i + 1..].each do |b,|
      joltage = a * 10 + b
      max = joltage if joltage > max
    end
  end

  sum += max
end

puts sum
