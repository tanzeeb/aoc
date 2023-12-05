#!/usr/bin/env ruby
# frozen_string_literal: true

require 'debug'

counts = Hash.new(0)

ARGF.readlines(chomp: true).each do |line|
  l,r = line.split(/:/)
  c = l.split(/\W+/).last.to_i
  w,n = r.split(/\|/).map{|p| p.strip.split(/\W+/).map(&:to_i)}
  m = (w & n).size

  counts[c] += 1

  m.times do |i|
    counts[c+i+1] += counts[c]
  end
end

puts counts.values.sum
