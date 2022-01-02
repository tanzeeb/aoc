#!/usr/bin/env ruby
# frozen_string_literal: true

min = -50
max = 50

steps = ARGF.readlines(chomp: true).map do |line|
  direction, ranges = line.split(' ')

  [direction == 'on', ranges.split(',').map {|r| r.split('=').last.split('..').map(&:to_i)}]
end

cubes = Hash.new(false)

steps.each do |(on,((xa,xb),(ya,yb),(za,zb)))|
  ([xa,min].max..[xb,max].min).each do |x|
    ([ya,min].max..[yb,max].min).each do |y|
      ([za,min].max..[zb,max].min).each do |z|
        cubes[[x,y,z]] = on
      end
    end
  end
end

puts cubes.count {|_,v| v}
