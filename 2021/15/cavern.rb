#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

map = ARGF.readlines(chomp: true).map { |line| line.split("").map(&:to_i) }

max_x = map.first.size - 1
max_y = map.size - 1

source = [0,0]
target = [max_x, max_y]

q = Set[]
dist = {}
prev = {}

(0..max_x).each do |x|
  (0..max_y).each do |y|
    v = [x,y]
    dist[v] = Float::INFINITY
    prev[v] = nil
    q << v
  end
end

dist[source] = 0

until q.empty?
  u = dist.select{|k,_| q.include? k}.sort_by{|_,v| v}.first.first

  q.delete u

  break if u == target

  ux, uy = u
  neighbours = []

  neighbours << [ux+1,uy] if ux < max_x
  neighbours << [ux-1,uy] if ux > 0
  neighbours << [ux,uy+1] if uy < max_y
  neighbours << [ux,uy-1] if uy > 0

  neighbours.select! { |v| q.include? v }

  neighbours.each do |v|
    vx, vy = v

    alt = dist[u] + map[vx][vy]

    if alt < dist[v]
      dist[v] = alt
      prev[v] = u
    end
  end
end

puts dist[target]
