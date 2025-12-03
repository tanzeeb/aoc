#!/usr/bin/env ruby
# frozen_string_literal: true

ranges = ARGF.readlines(chomp: true).join('').split(/,/).map do |range|
  Range.new(*range.split(/-/).map(&:to_i))
end

sum = 0

ranges.each do |range|
  range.each do |n|
    s = n.to_s
    sum += n if s[0...(s.size / 2)] == s[(s.size / 2)..]
  end
end

puts sum
