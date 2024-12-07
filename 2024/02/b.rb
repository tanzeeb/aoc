#!/usr/bin/env ruby
# frozen_string_literal: true

safe = 0

def safe?(levels)
  levels.reverse! if levels.first > levels.last

  levels.each_cons(2).map { |a, b| b - a }.all? { |d| d >= 1 && d <= 3 }
end

ARGF.readlines(chomp: true).each do |report|
  levels = report.split(/ /).map(&:to_i)

  perms = [levels]
  perms += levels.combination(levels.size - 1).to_a

  safe += 1 if perms.any? { |l| safe? l }
end

puts safe
