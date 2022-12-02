#!/usr/bin/env ruby
# frozen_string_literal: true

all = []
current = 0

ARGF.readlines(chomp: true).each do |line|
  if line.empty?
    all << current
    current = 0
  end

  current += line.to_i
end

all << current

top_3 = all.sort.last(3).sum

puts top_3

