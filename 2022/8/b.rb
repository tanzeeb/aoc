#!/usr/bin/env ruby
# frozen_string_literal: true

MAP = ARGF.readlines(chomp: true).map { |line| line.split(//).map(&:to_i) }

ROWS = MAP.size
COLS = MAP.first.size

def score row, col
  height = MAP[row][col]

  up = 0
  (row-1).downto(0).each do |i|
    up += 1
    break unless height > MAP[i][col]
  end

  down = 0
  (row+1).upto(ROWS-1).each do |i|
    down += 1
    break unless height > MAP[i][col]
  end

  left = 0
  (col-1).downto(0).each do |j|
    left += 1
    break unless height > MAP[row][j]
  end

  right = 0
  (col+1).upto(COLS-1).each do |j|
    right += 1
    break unless height > MAP[row][j]
  end

  up * down * left * right
end

max = 0
scores = (0...ROWS).map do |row|
  (0...COLS).map do |col|
    s = score(row,col)
    max = s if s > max
  end
end

puts max
