#!/usr/bin/env ruby
# frozen_string_literal: true

points = Hash.new(0)

ARGF.readlines.each do |line|
  x1, y1, x2, y2 = line.chomp.split(/,| -> /).map(&:to_i)

  x = x1
  y = y1

  dx = (x2-x1)/[(x2-x1).abs,1].max
  dy = (y2-y1)/[(y2-y1).abs,1].max

  loop do
    points[:"#{x},#{y}"] += 1

    break if x == x2 && y == y2

    x += dx
    y += dy
  end
end

puts points.select {|_,v| v > 1}.count

