#!/usr/bin/env ruby
# frozen_string_literal: true

safe = 0

ARGF.readlines(chomp: true).each do |report|
  levels = report.split(/ /).map(&:to_i)

  levels.reverse! if levels.first > levels.last

  safe += 1 if levels.each_cons(2).map { |a, b| b - a }.all? { |d| d >= 1 && d <= 3 }
end

puts safe
