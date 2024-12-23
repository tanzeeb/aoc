#!/usr/bin/env ruby
# frozen_string_literal: true

@map = ARGF.readlines(chomp: true).map { |line| line.split(//) }

@start = nil
@end = nil

@map.each_with_index do |row, i|
  row.each_with_index do |sym, j|
    @start = [[i, j], [0, 1]] if sym == 'S'
    @end = [[i, j], [0, 1]] if sym == 'E'
  end
end

@dirs = {
  [0, 1] => [[-1, 0], [1, 0]],
  [0, -1] => [[1, 0], [-1, 0]],
  [1, 0] => [[0, 1], [0, -1]],
  [-1, 0] => [[0, -1], [0, 1]]
}

@visited = Set.new
@unvisited = Set.new
@dist = Hash.new(Float::INFINITY)

@unvisited.add @start
@dist[@start] = 0

until @unvisited.empty?
  pos = @unvisited.min_by { |node| @dist[node] }

  @unvisited.delete pos
  @visited.add pos

  break if pos.first == @end.first

  moves = [
    [[pos.first, @dirs[pos.last].first], 1000],
    [[pos.first, @dirs[pos.last].last], 1000]
  ]

  forward = [pos.first.first + pos.last.first, pos.first.last + pos.last.last]

  moves << [[forward, pos.last], 1] unless @map[forward.first][forward.last] == '#'

  moves.each do |(node, cost)|
    next if @visited.include? node

    dist = @dist[pos] + cost

    @dist[node] = dist if dist < @dist[node]

    @unvisited.add node
  end

end

puts @dirs.keys.map { |dir| @dist[[@end.first, dir]] }.min
