#!/usr/bin/env ruby
# frozen_string_literal: true

@map = ARGF.readlines(chomp: true).map { |l| l.split(//).map(&:to_i) }

@rows = @map.size
@cols = @map.first.size

@scores = 0

@map.each_with_index do |row, i|
  row.each_with_index do |start, j|
    score = 0
    stack = []
    visited = Set.new

    stack.push [i, j] if start.zero?

    until stack.empty?
      pos = stack.pop
      height = @map[pos.first][pos.last]

      visited << pos

      if height == 9
        score += 1
      else
        [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |dir|
          adj = [pos.first + dir.first, pos.last + dir.last]

          next if adj.first.negative? || adj.first >= @rows || adj.last.negative? || adj.last >= @cols

          next unless @map[adj.first][adj.last] == height + 1

          next if visited.include? adj

          stack.push adj
        end
      end
    end

    @scores += score
  end
end

puts @scores
