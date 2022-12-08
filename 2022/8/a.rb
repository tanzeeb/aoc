#!/usr/bin/env ruby
# frozen_string_literal: true

map = ARGF.readlines(chomp: true).map { |line| line.split(//).map(&:to_i) }

ROWS = map.size
COLUMNS = map.first.size

left = Array.new(ROWS) { Array.new COLUMNS, false } 
right = Array.new(ROWS) { Array.new COLUMNS, false } 
up = Array.new(ROWS) { Array.new COLUMNS, false } 
down = Array.new(ROWS) { Array.new COLUMNS, false } 

(0...ROWS).each do |row|
  max = -1
  (0...COLUMNS).each do |col|
    if map[row][col] > max
      left[row][col] = true 
      max = map[row][col]
    end
  end
end

(0...ROWS).each do |row|
  max = -1
  (COLUMNS-1).downto(0).each do |col|
    if map[row][col] > max
      right[row][col] = true 
      max = map[row][col]
    end
  end
end

(0...COLUMNS).each do |col|
  max = -1
  (0...ROWS).each do |row|
    if map[row][col] > max
      up[row][col] = true 
      max = map[row][col]
    end
  end
end

(0...COLUMNS).each do |col|
  max = -1
  (ROWS-1).downto(0).each do |row|
    if map[row][col] > max
      down[row][col] = true 
      max = map[row][col]
    end
  end
end

count = 0

(0...ROWS).each do |row|
  (0...COLUMNS).each do |col|
    count += 1 if up[row][col] || down[row][col] || left[row][col] || right[row][col]
  end
end

puts count
