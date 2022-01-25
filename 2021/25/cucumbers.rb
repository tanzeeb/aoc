#!/usr/bin/env ruby
# frozen_string_literal: true

map = ARGF.readlines(chomp: true).map { |line| line.split(//) }

def step map
  right = Marshal.load(Marshal.dump(map))

  max_x = map.first.size
  max_y = map.size

  map.each_with_index do |row, y|
    row.each_with_index do |c, x|
      next unless c == '>'

      mx = (x+1) % max_x

      if map[y][mx] == '.'
        right[y][mx] = '>'
        right[y][x] = '.'
      end
    end
  end

  down = Marshal.load(Marshal.dump(right))

  map.each_with_index do |row, y|
    row.each_with_index do |c, x|
      next unless c == 'v'

      my = (y+1) % max_y

      if right[my][x] == '.'
        down[my][x] = 'v'
        down[y][x] = '.'
      end
    end
  end

  down
end

def draw map
  map.each_with_index do |row, y|
    row.each_with_index do |c, x|
      putc c
    end
    puts ""
  end
end

steps = 0
new = map
current = nil

while current != new
  steps += 1
  current = new

  new = step(current)
end

puts steps
