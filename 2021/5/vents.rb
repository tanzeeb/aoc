#!/usr/bin/env ruby
# frozen_string_literal: true

points = Hash.new(0)

ARGF.readlines.each do |line|
  x1, y1, x2, y2 = line.chomp.split(/,| -> /).map(&:to_i)

  next unless x1 == x2 || y1 == y2

  ([x1,x2].min..[x1,x2].max).each do |x|
    ([y1,y2].min..[y1,y2].max).each do |y|
      points[:"#{x},#{y}"] += 1
    end
  end
end

puts points.select {|_,v| v > 1}.count

