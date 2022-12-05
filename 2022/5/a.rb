#!/usr/bin/env ruby
# frozen_string_literal: true

moves = []
stacks = Hash.new { |h,k| h[k] = [] }

ARGF.readlines(chomp: true).each do |line|
  case line

  when /^move/
    count, from, to = line.scan(/\d+/).map(&:to_i)
    moves << [ count, from, to ]

  when /\[[A-Z]\]/
    line.split(//).each_slice(4).with_index do |(_,crate,_,_),i|
      stacks[i+1].prepend crate unless crate.strip.empty?
    end

  end
end

moves.each do |(count, from, to)|
  count.times do
    crate = stacks[from].pop
    stacks[to].push crate
  end
end

puts stacks.keys.sort.map { |k| stacks[k].last }.join("")
