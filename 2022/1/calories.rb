#!/usr/bin/env ruby
# frozen_string_literal: true

max = 0
current = 0

ARGF.readlines(chomp: true).each do |line|
  if line.empty?
    max = current if current > max
    current = 0
  end

  current += line.to_i
end

puts max

