#!/usr/bin/env ruby
# frozen_string_literal: true

require 'debug'

h = Hash.new { |h,k| h[k] = [] }

seeds = []
stack = []

ARGF.readlines(chomp: true).each do |line|
  case line
  when /^seeds: (.+)$/
    seeds = []
    $1.split(/\W+/).map(&:to_i).each_slice(2) { |a,b| seeds << (a...(a+b)) }
  when /^(\w+)-to-(\w+) map:$/
    stack << $2.to_sym
  when /^(\d+) (\d+) (\d+)$/
    h[stack.last] << { range: $2.to_i...($2.to_i+$3.to_i), offset: $1.to_i - $2.to_i }
  end
end

tr = stack.inject(seeds) do |ranges, lookup|
  b = nil
  t = ranges.dup
  e = []

  h[lookup].each do |d|
    b = t
    t = []

    while r = b.shift
      if d[:range].min > r.max || d[:range].max < r.min
        t << r
        next
      end

      if d[:range].min <= r.min && d[:range].max >= r.max
        e << ( (r.min + d[:offset])..(r.max + d[:offset]) )
        next
      end
      
      if d[:range].min <= r.min && d[:range].max < r.max
        e << ( (r.min + d[:offset])..(d[:range].max + d[:offset]) )
        t << ( (d[:range].max+1)..(r.max) )
        next
      end

      if d[:range].min > r.min && d[:range].max >= r.max
        t << ( (r.min)..(d[:range].min-1) )
        e << ( (d[:range].min + d[:offset])..(r.max + d[:offset]) )
        next
      end

      if d[:range].min > r.min && d[:range].max < r.max
        t << ( (r.min)..(d[:range].min-1) )
        e << ( (d[:range].min + d[:offset])..(d[:range].max + d[:offset]) )
        t << ( (d[:range].max+1)..(r.max) )
        next
      end

      throw "shouldn't happen"
    end
  end

  e + t
end

puts tr.map(&:min).min
