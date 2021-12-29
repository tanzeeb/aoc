#!/usr/bin/env ruby
# frozen_string_literal: true

m = /target area: x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)/.match ARGF.readline

@min_x = m[1].to_i
@max_x = m[2].to_i
@min_y = m[3].to_i
@max_y = m[4].to_i

def target? dx, dy
  x = 0
  y = 0
  peak = 0

  until y < @min_y
    x += dx
    y += dy

    peak = y if y > peak

    if dx > 0
      dx -= 1
    elsif dx < 0
      dx += 1
    end

    dy -= 1

    return true, peak if x >= @min_x && x <= @max_x && y >= @min_y && y <= @max_y
  end

  return false, peak
end

@peak = 0

(0..@max_x).each do |dx|
  (0..@max_x).each do |dy|
    hit, peak = target? dx, dy

    @peak = peak if hit && peak > @peak
  end
end

puts @peak
