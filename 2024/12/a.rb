#!/usr/bin/env ruby
# frozen_string_literal: true

@map = ARGF.readlines(chomp: true).map { |l| l.split(//) }

@rows = @map.size
@cols = @map.first.size

@plots = Set.new

@map.each_with_index do |row, i|
  row.each_with_index do |_, j|
    @plots << [i, j]
  end
end

@regions = []

until @plots.empty?
  start = @plots.first
  region = Set.new

  queue = [start]
  plant = @map[start.first][start.last]

  until queue.empty?
    plot = queue.pop

    next if region.include? plot
    next unless @plots.include? plot

    next unless @map[plot.first][plot.last] == plant

    region << plot

    queue << [plot.first + 1, plot.last]
    queue << [plot.first - 1, plot.last]
    queue << [plot.first, plot.last + 1]
    queue << [plot.first, plot.last - 1]
  end

  @plots.subtract region
  @regions << region
end

puts(@regions.sum do |r|
  r.size * r.sum do |p|
    [
      r.include?([p.first + 1, p.last]),
      r.include?([p.first - 1, p.last]),
      r.include?([p.first, p.last + 1]),
      r.include?([p.first, p.last - 1])
    ].count(false)
  end
end)
