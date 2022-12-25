#!/usr/bin/env ruby
# frozen_string_literal: true

puts "---"

*map, _, path = ARGF.readlines(chomp: true).map {|l| l.split(//)}

pp map
pp path

nodes = {}

Node = Struct.new(:x,:y,:up,:down,:left,:right) do
end

start = nil

rows = map.size
cols = map.map(&:size).max

ups = Array.new(cols,Float::INFINITY)
downs = Array.new(cols,-Float::INFINITY)
lefts = Array.new(rows,Float::INFINITY)
rights = Array.new(rows,-Float::INFINITY)

map.each.with_index do |line,y|
  line.each.with_index do |tile,x|
    next if tile == " "

    nodes[[x,y]] = Node.new(x,y) if tile == "."

    ups[x] = y if y < ups[x]
    downs[x] = y if y > downs[x]

    lefts[y] = x if x < lefts[y]
    rights[y] = x if x > rights[y]
  end
end

pp rows
pp cols

pp ups
pp downs
pp lefts
pp rights

nodes.each do |(x,y),node|
  left = [ x-1 < lefts[y] ? rights[y] : x-1, y]
  right = [ x+1 > rights[y] ? lefts[y] : x+1, y]
  up = [x, y-1 < ups[x] ? downs[x] : y-1]
  down = [x, y+1 > downs[x] ? ups[x] : y+1 ]

  node.left = nodes[left] unless map[left.last][left.first] == "#"
  node.right = nodes[right] unless map[right.last][right.first] == "#"
  node.up = nodes[up] unless map[up.last][up.first] == "#"
  node.down = nodes[down] unless map[down.last][down.first] == "#"
end

def draw nodes, rows, cols
  puts rows.times.map { |y|
    cols.times.map { |x|
      if node = nodes[[x,y]]
        mask = 0
        mask += 1 if node.up
        mask += 2 if node.right
        mask += 4 if node.down
        mask += 8 if node.left

        mask.to_s(16)
      else
        " "
      end
    }.join("")
  }.join("\n")
end

draw nodes, rows, cols
