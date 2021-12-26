#!/usr/bin/env ruby
# frozen_string_literal: true

map = ARGF.readlines.map { |line| line.chomp.split('').map(&:to_i) }

def adjacents(i,j, map)
  rows = map.first.size
  cols = map.size

  [].tap do |adjacents|
    adjacents << [i,j+1] if j+1 < rows
    adjacents << [i,j-1] if j-1 >= 0
    adjacents << [i+1,j] if i+1 < cols
    adjacents << [i-1,j] if i-1 >= 0
  end
end

def score(i,j, map)
  marks = Hash.new do |m,(i,j)|
    if map[i][j] == 9
      m[[i,j]] = false
    else
      m[[i,j]] = true

      adjacents(i,j,map).each { |a| m[a] }
    end
  end

  marks[[i,j]]

  marks.values.filter {|v| v}.size
end

basins = []

map.each_with_index do |row, i|
  row.each_with_index do |value, j|
    low = adjacents(i,j,map).all? { |ni,nj| value < map[ni][nj] }

    basins << score(i,j, map) if low
  end
end

puts basins.sort.last(3).reduce(:*)
