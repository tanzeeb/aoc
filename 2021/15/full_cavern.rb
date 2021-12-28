#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

tile = ARGF.readlines(chomp: true).map { |line| line.split("").map(&:to_i) }

rows = tile.size
cols = tile.first.size

map = (0...rows*5).map do |x|
  (0...cols*5).map do |y|
    (tile[x%cols][y%rows] + x/rows + y/cols - 1) % 9 + 1
  end
end

max_x = map.first.size - 1
max_y = map.size - 1

source = [0,0]
target = [max_x, max_y]

q = Set[source]
dist = Hash.new(Float::INFINITY)
dist[source] = 0
qdist = dist.dup
discard = Set[]

until q.empty?
  u = qdist.min_by{|_,v| v }.first

  q.delete u
  qdist.delete u
  discard << u

  break if u == target

  ux, uy = u
  neighbours = []

  neighbours << [ux+1,uy] if ux < max_x
  neighbours << [ux-1,uy] if ux > 0
  neighbours << [ux,uy+1] if uy < max_y
  neighbours << [ux,uy-1] if uy > 0

  neighbours.reject! { |v| discard.include? v }

  neighbours.each do |v|
    vx, vy = v

    alt = dist[u] + map[vx][vy]

    if alt < dist[v]
      q.add v
      dist[v] = alt
      qdist[v] = alt
    end
  end
end

puts dist[target]
