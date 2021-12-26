#!/usr/bin/env ruby
# frozen_string_literal: true

map = ARGF.readlines.map { |line| line.chomp.split('').map(&:to_i) }

rows = map.first.size
cols = map.size

sum = 0

map.each_with_index do |row, i|
  row.each_with_index do |value, j|
    adjacents = []

    adjacents << map[i][j+1] if j+1 < rows
    adjacents << map[i][j-1] if j-1 >= 0
    adjacents << map[i+1][j] if i+1 < cols
    adjacents << map[i-1][j] if i-1 >= 0

    low = adjacents.all? { |a| value < a }

    sum += value + 1 if low
  end
end

puts sum
