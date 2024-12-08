#!/usr/bin/env ruby
# frozen_string_literal: true

@map = ARGF.readlines(chomp: true).map { |line| line.split(//) }
@rows = @map.size
@cols = @map.first.size

@antennas = Hash.new { |h, k| h[k] = [] }

@nodes = Set.new
@antinodes = Set.new

@map.each_with_index do |row, i|
  row.each_with_index do |col, j|
    next if col == '.'

    @nodes << [i, j]
    @antennas[col] << [i, j]
  end
end

@antennas.each_value do |locations|
  locations.permutation(2).each do |a, b|
    delta = [b.first - a.first, b.last - a.last]
    antinode = [b.first + delta.first, b.last + delta.last]

    next unless antinode.first >= 0 && antinode.last >= 0 && antinode.first < @rows && antinode.last < @cols

    @antinodes << antinode
  end
end

def draw
  @map.each_with_index do |row, i|
    row.each_with_index do |col, j|
      if @antinodes.include?([i, j]) && col == '.'
        print '#'
      else
        print col
      end
    end
    puts
  end
end

puts @antinodes.size
