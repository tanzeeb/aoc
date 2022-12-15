#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

#MAX = 20
MAX = 4000000

tunnels = {}

ARGF.readlines(chomp: true).each do |line|
  _, sx, _, sy, _, bx, _, by = line.split(/[=,:]/)

  tunnels[[sx.to_i,sy.to_i]] = [bx.to_i,by.to_i]
end

def dist a, b
  (a.first - b.first).abs + (a.last - b.last).abs
end

def merge ranges
  sorted = ranges.sort_by { |r| r.begin }

  merged = [sorted.shift]

  sorted.each do |range|
    if range.cover?(merged.last.first) || merged.last.cover?(range.first)
      last = merged.pop
      merged << ([range.begin,last.begin].min..[range.end,last.end].max)
    else
      merged << range
    end
  end

  merged
end

def scan tunnels, y, max
  ranges = []

  tunnels.each do |sensor, beacon|
    return nil if beacon.last == y && beacon.first >= 0 && beacon.first <= max

    radius = dist sensor, beacon
    down = dist sensor, [sensor.first, y]
    delta = radius - down

    next unless delta > 0

    ranges << ([sensor.first-delta,0].max..[sensor.first+delta,max].min)
  end

  ranges = merge ranges

  return nil if ranges.map {|r| r.size}.sum == max+1

  case ranges
  in [Range]
    return ranges.first.begin == 0 ? 0 : max
  in [Range,Range]
    return ranges.first.end + 1
  end
end

y = 0
x = nil

y += 1 until y > MAX || x = scan(tunnels, y, MAX)

puts 4000000*x+y
