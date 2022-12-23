#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

puts "---"

elves = Set[]

ARGF.readlines(chomp: true).each.with_index do |line,y|
  line.split(//).each.with_index do |tile,x|
    elves << [x,y] if tile == "#"
  end
end

def rectangle elves
  min_x, max_x = elves.minmax_by {|(x,_)| x}.map(&:first)
  min_y, max_y = elves.minmax_by {|(_,y)| y}.map(&:last)

  [ (min_x..max_x).size, (min_y..max_y).size ]
end

def draw elves
  min_x, max_x = elves.minmax_by {|(x,_)| x}.map(&:first)
  min_y, max_y = elves.minmax_by {|(_,y)| y}.map(&:last)

  puts (min_y.pred..max_y.succ).map { |y|
    (min_x.pred..max_x.succ).map { |x| 
      elves.include?([x,y]) ? "x" : "." 
    }.join("")
  }.join("\n")
end

def round elves, order
  new = Set[]
  proposals = Hash.new {|h,k| h[k] = [] }

  elves.each do |elf|
    if alone? elf, elves
      new << elf
    else
      p = proposal elf, elves, order
      if p
        proposals[p] << elf
      else
        new << elf
      end
    end
  end

  proposals.each do |p,cs|
    if cs.size == 1
      new << p
    else
      new.merge cs
    end
  end

  raise "error #{elves.size} vs #{new.size}, missing #{elves - new}" if elves.size != new.size

  new
end

def proposal elf, elves, order
  x, y = elf

  order.each do |dir|
    case dir
    when :north
      return [x,y-1] if [ [x,y-1], [x+1,y-1], [x-1,y-1] ].all? { |p| !elves.include? p }
    when :south
      return [x,y+1] if [ [x,y+1], [x+1,y+1], [x-1,y+1] ].all? { |p| !elves.include? p }
    when :west
      return [x-1,y] if [ [x-1,y], [x-1,y+1], [x-1,y-1] ].all? { |p| !elves.include? p }
    when :east
      return [x+1,y] if [ [x+1,y], [x+1,y+1], [x+1,y-1] ].all? { |p| !elves.include? p }
    end
  end

  nil
end

def alone? elf, elves
  x, y = elf

  [
    [x-1,y-1], [x,y-1], [x+1,y-1],
    [x-1,y], [x+1,y],
    [x-1,y+1], [x,y+1], [x+1,y+1],
  ].all? { |p| !elves.include? p }
end

order = [:north, :south, :west, :east]

#draw elves

10.times do |i|
  elves = round elves, order

  #puts "#{i+1}:"
  #draw elves

  order.rotate!
end

x, y = rectangle elves
empty = x*y - elves.size

puts empty
