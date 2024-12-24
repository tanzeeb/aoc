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
@prev = Hash.new { |h, k| h[k] = Set.new }

@unvisited.add @start
@dist[@start] = 0

until @unvisited.empty?
  pos = @unvisited.min_by { |node| @dist[node] }

  @unvisited.delete pos
  @visited.add pos

  # break if pos.first == @end.first

  moves = [
    [[pos.first, @dirs[pos.last].first], 1000],
    [[pos.first, @dirs[pos.last].last], 1000]
  ]

  forward = [pos.first.first + pos.last.first, pos.first.last + pos.last.last]

  moves << [[forward, pos.last], 1] unless @map[forward.first][forward.last] == '#'

  moves.each do |(node, cost)|
    next if @visited.include? node

    dist = @dist[pos] + cost

    if dist < @dist[node]
      @dist[node] = dist
      @prev[node.first] = Set[pos.first] unless node.first == pos.first
    end

    @prev[node.first] << pos.first if dist == @dist[node] && node.first != pos.first

    @unvisited.add node
  end

end

pp @prev
pp @prev.size

count = 0
@paths = [@end.first]
@shortest = Set.new

until @paths.empty?
  path = @paths.shift

  @shortest.add path

  break if path == @start.first

  @prev[path].each { |n| @paths.append n unless @shortest.include? n }

  count += 1
end

puts count
