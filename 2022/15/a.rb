#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

tunnels = {}

ARGF.readlines(chomp: true).each do |line|
  _, sx, _, sy, _, bx, _, by = line.split(/[=,:]/)

  tunnels[[sx.to_i,sy.to_i]] = [bx.to_i,by.to_i]
end

def dist a, b
  (a.first - b.first).abs + (a.last - b.last).abs
end

def clear tunnels, y
  cleared = Set.new

  tunnels.each do |sensor, beacon|
    radius = dist sensor, beacon
    down = dist sensor, [sensor.first, y]
    delta = radius - down

    next unless delta > 0

    range = Range.new *[sensor.first+delta, sensor.first-delta].sort

    range.each do |x|
      cleared << x
    end

    cleared.delete(beacon.first) if beacon.last == y
  end

  cleared.size
end

puts clear tunnels, 10
puts clear tunnels, 2000000
