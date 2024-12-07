#!/usr/bin/env ruby
# frozen_string_literal: true

@board = ARGF.readlines(chomp: true).map { |row| row.split(//) }

@rows = @board.size
@cols = @board.first.size

@directions = [
  [-1, 1],
  [-1, -1],
  [1, 1],
  [1, -1]
]

@word = 'MAS'.split(//)

def count(word, row, col)
  @directions.count { |d| find word, row, col, d }
end

def find(word, row, col, direction)
  return true if word.empty?
  return false if row.negative? || row >= @rows || col.negative? || col >= @cols

  return false unless word.first == @board[row][col]

  find(word[1..], row + direction.first, col + direction.last, direction)
end

@marks = Hash.new(0)

@rows.times do |i|
  @cols.times do |j|
    @directions.each do |d|
      @marks[[i + d.first, j + d.last]] += 1 if find(@word, i, j, d)
    end
  end
end

puts(@marks.count { |_k, v| v > 1 })
