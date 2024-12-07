#!/usr/bin/env ruby
# frozen_string_literal: true

@board = ARGF.readlines(chomp: true).map { |row| row.split(//) }

@rows = @board.size
@cols = @board.first.size

@directions = [
  [0, 1],
  [0, -1],
  [1, 0],
  [-1, 0],
  [-1, 1],
  [-1, -1],
  [1, 1],
  [1, -1]
]

@word = 'XMAS'.split(//)

def count(word, row, col)
  @directions.count { |d| find word, row, col, d }
end

def find(word, row, col, direction)
  return true if word.empty?
  return false if row.negative? || row >= @rows || col.negative? || col >= @cols

  return false unless word.first == @board[row][col]

  find(word[1..], row + direction.first, col + direction.last, direction)
end

sum = 0

@rows.times do |i|
  @cols.times do |j|
    sum += count(@word, i, j)
  end
end

puts sum
