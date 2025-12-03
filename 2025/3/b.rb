#!/usr/bin/env ruby
# frozen_string_literal: true

sum = 0

ARGF.readlines(chomp: true).each do |line|
  batteries = line.split(//).map(&:to_i)

  max = 0

  batteries.combination(12).each do |combo|
    joltage = combo.map(&:to_s).join('').to_i

    max = joltage if joltage > max
  end

  sum += max
end

puts sum
