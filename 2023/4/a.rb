#!/usr/bin/env ruby
# frozen_string_literal: true

require 'debug'

puts ARGF.readlines(chomp: true).map { |line|
  w,n = line.split(/:/)[1].split(/\|/).map{|p| p.strip.split(/\W+/).map(&:to_i)}
  m = w & n

  m.size > 0 ? 2**m.size.pred : 0
}.sum

