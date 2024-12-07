#!/usr/bin/env ruby
# frozen_string_literal: true

left = []
right = []
dist = []

ARGF.readlines(chomp: true).each do |line|
  l, r = line.split(/\W+/).map(&:to_i)

  left << l
  right << r
end

left.sort!
right.sort!

left.zip(right) do |l, r|
  dist << (l - r).abs
end

puts dist.sum
