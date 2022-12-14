#!/usr/bin/env ruby
# frozen_string_literal: true

START = [500,0]

max_y = START.last

cave = { [500,0] => "+"}

def draw cave
  points = cave.keys

  min_x = points.min_by {|(x,_)| x}.first
  min_y = points.min_by {|(_,y)| y}.last
  max_x = points.max_by {|(x,_)| x}.first
  max_y = points.max_by {|(_,y)| y}.last

  (min_y..max_y).each do |y|
    row = (min_x..max_x).map do |x|
      cave[[x,y]] ? cave[[x,y]] : "."
    end
    puts row.join("")
  end
end

ARGF.readlines(chomp: true).each do |line|
  line.split(/ -> /).each_cons(2) do |from, to|
    from_x, from_y = from.split(/,/).map(&:to_i)
    to_x, to_y = to.split(/,/).map(&:to_i)

    max_y = [to_y, from_y, max_y].max


    if from_x == to_x
      Range.new(*[from_y,to_y].sort).each do |y|
        cave[[to_x,y]] = "#"
      end
    else
      Range.new(*[from_x,to_x].sort).each do |x|
        cave[[x,to_y]] = "#"
      end
    end
  end
end

def drop cave, max_y
  x, y = START

  loop do
    if y < max_y && cave[[x,y+1]].nil?
      y += 1
    elsif y < max_y && cave[[x-1,y+1]].nil?
      x -= 1
      y += 1
    elsif y < max_y && cave[[x+1,y+1]].nil?
      x += 1
      y += 1
    else
      cave[[x,y]] = "o"

      return [x,y] == START
    end
  end
end

count = 1

until drop(cave, max_y+1)
  count += 1
end

puts count
