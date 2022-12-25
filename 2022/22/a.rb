#!/usr/bin/env ruby
# frozen_string_literal: true

puts "---"

*map, _, path = ARGF.readlines(chomp: true).map {|l| l.split(//)}

nodes = {}

Node = Struct.new(:x,:y,:up,:down,:left,:right) do
  def to_s
    { x: x, y: y }.to_s
  end

  def inspect
    { x: x, y: y }.inspect
  end
end

Position = Struct.new(:node, :facing) do
  def rotate direction
    case direction
    when "R"
      self.facing = (self.facing+1) % 4
    when "L"
      self.facing = (self.facing-1) % 4
    end
  end

  def move count
    @directions ||= [:right, :down, :left, :up]

    count.times do
      self.node = self.node.send @directions[self.facing]
    end
  end

  def to_s
    { x: node.x, y: node.y, dir: facing }.to_s
  end

  def inspect
    { x: node.x, y: node.y, dir: facing }.inspect
  end
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

    if tile == "."
      node = Node.new(x,y)

      nodes[[x,y]] = node
      start ||= node
    end

    ups[x] = y if y < ups[x]
    downs[x] = y if y > downs[x]

    lefts[y] = x if x < lefts[y]
    rights[y] = x if x > rights[y]
  end
end

nodes.each do |(x,y),node|
  left = [ x-1 < lefts[y] ? rights[y] : x-1, y]
  right = [ x+1 > rights[y] ? lefts[y] : x+1, y]
  up = [x, y-1 < ups[x] ? downs[x] : y-1]
  down = [x, y+1 > downs[x] ? ups[x] : y+1 ]

  node.left = node
  node.right = node
  node.up = node
  node.down = node

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
        mask += 1 unless node.up == node
        mask += 2 unless node.right == node
        mask += 4 unless node.down == node
        mask += 8 unless node.left == node

        mask.to_s(16)
      else
        " "
      end
    }.join("")
  }.join("\n")
end

position = Position.new(start, 0)

path.join("").scan(/(\d+)([RL]?)/) do |(moves,turn)|
  position.move(moves.to_i)
  position.rotate(turn) unless turn.empty?
end

puts [(position.node.y+1)*1000, (position.node.x+1)*4, position.facing].sum
