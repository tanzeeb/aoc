#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

grid = Set[]

ARGF.readlines(chomp: true).each do |line|
  x, y, z = line.split(/,/).map(&:to_i)

  grid << [x,y,z]
end

min = [grid.min_by {|x,_,_| x}[0]-1, grid.min_by {|_,y,_| y}[1]-1, grid.min_by {|_,_,z| z}[2]-1]
max = [grid.max_by {|x,_,_| x}[0]+1, grid.max_by {|_,y,_| y}[1]+1, grid.max_by {|_,_,z| z}[2]+1]

exterior = Set[]

def fill grid, exterior, cube, min, max, queue
  return if grid.include?(cube)
  return if exterior.include?(cube)

  return if [
    cube[0] < min[0],
    cube[1] < min[1],
    cube[2] < min[2],
    cube[0] > max[0],
    cube[1] > max[1],
    cube[2] > max[2],
  ].any?

  exterior << cube

  x,y,z = *cube
  [
    [x+1,y,z],
    [x-1,y,z],
    [x,y+1,z],
    [x,y-1,z],
    [x,y,z+1],
    [x,y,z-1],
  ].each { |adj| queue << adj }
end

queue = [min]

while cube = queue.shift
  fill grid, exterior, cube, min, max, queue
end

def area exterior, cube
  x,y,z = *cube
  [
    [x+1,y,z],
    [x-1,y,z],
    [x,y+1,z],
    [x,y-1,z],
    [x,y,z+1],
    [x,y,z-1],
  ].select { |adj| exterior.include?(adj) }.size
end

puts grid.sum {|cube| area exterior, cube}
