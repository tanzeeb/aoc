#!/usr/bin/env ruby
# frozen_string_literal: true

counts = nil
total = 0

ARGF.readlines.each do |line|
  counts = Array.new(line.size - 1, 0) if counts.nil?

  line.split('').each_with_index do |v, i|
    counts[i] += 1 if v == '1'
  end

  total += 1
end

majority = total / 2
gamma = []
epsilon = []

counts.each do |count|
  gamma << (count > majority ? '1' : '0')
  epsilon << (count < majority ? '1' : '0')
end

puts gamma.join.to_i(2) * epsilon.join.to_i(2)
