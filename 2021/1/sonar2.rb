#!/usr/bin/env ruby
# frozen_string_literal: true

inc = 0
measurements = []

ARGF.readlines.each do |line|
  measurement = line.to_i

  last = measurements.last(3).sum
  current = measurements.last(2).sum + measurement

  puts "#{measurement} - #{last} - #{current} - #{current > last}"

  inc += 1 if measurements.length > 2 && current > last

  measurements << measurement
end

puts inc
