#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

map = ARGF.readlines(chomp: true).map do |line|
  line.split(//)
end

rows = map.size
cols = map.first.size

source = nil
target = nil

q = Set[]
dist = Hash.new(Float::INFINITY)
prev = Hash.new(nil)


map.each_with_index do |r,i|
  r.each_with_index do |c,j|
    v = [i,j]

    case c
    when "S"
      map[i][j] = "a"
      dist[v] = 0
    when "E"
      target = [i,j]
      map[i][j] = "z"
    when "a"
      dist[v] = 0
    end

    q << v
  end
end

dist[source] = 0

until q.empty?
  u = dist.select{|k,_| q.include? k}.sort_by{|_,v| v}.first.first

  q.delete u

  break if u == target

  ui,uj = u
  neighbours = []

  neighbours << [ui+1,uj] if ui < rows-1
  neighbours << [ui-1,uj] if ui > 0

  neighbours << [ui,uj+1] if uj < cols-1
  neighbours << [ui,uj-1] if uj > 0

  neighbours.reject! {|v| (map[v.first][v.last].ord - map[u.first][u.last].ord) > 1 }

  neighbours.each do |v|
    alt = dist[u] + 1

    if alt < dist[v]
      dist[v] = alt
    end
  end
end

puts dist[target]
