#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

dots = Set.new 
folds = []

ARGF.readlines(chomp: true).each do |line|
  case line
  when /\d+,\d+/
    x,y = line.split(',').map(&:to_i)
    dots << { x: x, y: y }
  when /fold along x=\d+/
    folds << {x: line.split('=').last.to_i}
  when /fold along y=\d+/
    folds << {y: line.split('=').last.to_i}
  end
end

folds[0..0].each do |fold|
  dots.each do |dot|
    dot[:x] = 2*fold[:x] - dot[:x] if fold[:x] && fold[:x] < dot[:x]
    dot[:y] = 2*fold[:y] - dot[:y] if fold[:y] && fold[:y] < dot[:y]
  end

  dots.reset
end

puts dots.size
