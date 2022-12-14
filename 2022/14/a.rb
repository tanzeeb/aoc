#!/usr/bin/env ruby
# frozen_string_literal: true

START = [500,0]

min_x = START.first
max_x = START.first
min_y = START.last
max_y = START.last

cave = { [500,0] => "+"}

def draw cave, min_x, max_x, min_y, max_y
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

    min_x = [to_x, from_x, min_x].min
    min_y = [to_y, from_y, min_y].min
    max_x = [to_x, from_x, max_x].max
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

# draw cave, min_x, max_x, min_y, max_y

def drop cave, max_y
  x, y = START

  until y > max_y
    if cave[[x,y+1]].nil?
      y += 1
    elsif cave[[x-1,y+1]].nil?
      x -= 1
      y += 1
    elsif cave[[x+1,y+1]].nil?
      x += 1
      y += 1
    else
      cave[[x,y]] = "o"
      return true
    end
  end

  false
end

count = 0
count += 1 while drop(cave, max_y)

puts count
