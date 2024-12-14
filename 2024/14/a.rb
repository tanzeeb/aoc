#!/usr/bin/env ruby
# frozen_string_literal: true

@rows = 103
@cols = 101

if ARGV.first != 'input.txt'
  @rows = 7
  @cols = 11
end

@robots = ARGF.readlines(chomp: true).map do |line|
  line.split(' ').map do |part|
    part.split('=').last.split(',').map(&:to_i)
  end
end

@positions = Hash.new(0)

def draw
  @rows.times do |y|
    @cols.times do |x|
      c = @positions[[x, y]]
      print c.zero? ? '.' : c.to_s
    end
    puts
  end
end

@robots.each do |(s, v)|
  i = 100
  p = [
    (s.first + (i * v.first)) % @cols,
    (s.last + (i * v.last)) % @rows
  ]

  @positions[p] += 1
end

tl = @positions.sum { |p, c| p.first < @cols / 2 && p.last < @rows / 2 ? c : 0 }
tr = @positions.sum { |p, c| p.first > @cols / 2 && p.last < @rows / 2 ? c : 0 }
bl = @positions.sum { |p, c| p.first > @cols / 2 && p.last > @rows / 2 ? c : 0 }
br = @positions.sum { |p, c| p.first < @cols / 2 && p.last > @rows / 2 ? c : 0 }

puts tl * tr * br * bl
