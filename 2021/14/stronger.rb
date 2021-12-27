#!/usr/bin/env ruby
# frozen_string_literal: true

STEPS = 40

pairs = Hash.new(0)

template = ARGF.readline.chomp.split("")

template.each_cons(2) do |(a,b)|
  pairs[[a,b]] += 1
end

ARGF.readline

rules = {}

ARGF.readlines(chomp: true).each do |line|
  pair, element = line.split(/ -> /)

  rules[ pair.split("") ] = element
end

STEPS.times do 
  new_pairs = Hash.new(0)

  pairs.each do |pair,count|
    insert = rules[pair]

    first = [pair.first, insert]
    last = [insert, pair.last]

    [first,last].each do |new_pair|
      new_pairs[new_pair] += count
    end
  end

  pairs = new_pairs
end

counts = Hash.new(0)

pairs.each do |(a,_),count|
  counts[a] += count
end

counts[template.last] += 1

min,max = counts.values.minmax

puts max - min
