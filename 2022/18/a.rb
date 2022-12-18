#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

grid = Set[]

ARGF.readlines(chomp: true).each do |line|
  x, y, z = line.split(/,/).map(&:to_i)

  grid << [x,y,z]
end

def area grid, cube
  x,y,z = *cube
  [
    [x+1,y,z],
    [x-1,y,z],
    [x,y+1,z],
    [x,y-1,z],
    [x,y,z+1],
    [x,y,z-1],
  ].reject { |adj| grid.include? adj }.size
end

puts grid.sum {|cube| area grid, cube}
