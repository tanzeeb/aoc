#!/usr/bin/env ruby
# frozen_string_literal: true

segments = []
sizes = Hash.new(0)
dirs = []

files = {}

ARGF.readlines(chomp: true).each do |line|
  case line
  when /^\$ cd ..$/
    segments.pop
  when /^\$ cd \/$/
    segments.push ""
  when /^\$ cd ([a-z]+)$/
    segment = $1
    segments.push segment
  when /^([0-9]+) ([a-z.]+)$/
    size = $1.to_i
    sizes[segments.join("/")] += size
  when /^dir ([a-z]+)$/
    segment = $1
    path = segments.join("/")
    dir = path + "/" + segment
    dirs.push [dir, path]
  end
end

dirs.sort_by do |(_,path)| 
  path.size
end.reverse.each do |(dir,path)|
  sizes[path] += sizes[dir]
end

puts sizes.values.select {|v| v <= 100000}.sum
